//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0] pc, pcnormal, pcbranch, pcnew;
wire [31:0] instr;
wire [4:0]  regtow;
wire [31:0] signext, sl2addr;
wire [31:0] rdata1, rdata2;
wire [31:0] aludata2;
wire [31:0] aluresult;
wire [31:0] memdata;
wire [31:0] wdata;
wire        zero;
wire        c_regdst, c_branch, c_alusrc, c_regw;
wire        c_jump, c_memr, c_memw, c_mtor;
wire [2:0]  c_aluop;
wire [3:0]  c_aluctrl;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),
	    .rst_i(rst_i),
	    .pc_in_i(pcnew) ,
	    .pc_out_o(pc)
	    );

Adder Adder1(
        .src1_i(pc),
	    .src2_i(32'd4),
	    .sum_o(pcnormal)
	    );

Instr_Memory IM(
        .pc_addr_i(pc),
	    .instr_o(instr)
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(c_regdst),
        .data_o(regtow)
        );

Reg_File Registers(
        .clk_i(clk_i),
	    .rst_i(rst_i),
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(regtow),
        .RDdata_i(wdata),
        .RegWrite_i (c_regw),
        .RSdata_o(rdata1),
        .RTdata_o(rdata2)
        );

Decoder Decoder(
        .instr_op_i(instr[31:26]),
	    .RegWrite_o(c_regw),
	    .ALU_op_o(c_aluop),
	    .ALUSrc_o(c_alusrc),
	    .RegDst_o(c_regdst),
		.Branch_o(c_branch),
        .Jump_o(c_jump),
        .MemRead_o(c_memr),
        .MemWrite_o(c_memw),
        .MemtoReg_o(c_mtor)
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),
        .ALUOp_i(c_aluop),
        .ALUCtrl_o(c_aluctrl)
        );

Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(signext)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rdata2),
        .data1_i(signext),
        .select_i(c_alusrc),
        .data_o(aludata2)
        );

ALU ALU(
        .src1_i(rdata1),
	    .src2_i(aludata2),
	    .ctrl_i(c_aluctrl),
	    .result_o(aluresult),
		.zero_o(zero)
	    );

Data_Memory Data_Memory(
	    .clk_i(clk_i),
	    .addr_i(aluresult),
	    .data_i(rdata2),
	    .MemRead_i(c_memr),
	    .MemWrite_i(c_memw),
	    .data_o(memdata)
	    );

Adder Adder2(
        .src1_i(pcnormal),
	    .src2_i(sl2addr),
	    .sum_o(pcbranch)
	    );

Shift_Left_Two_32 Shifter(
        .data_i(signext),
        .data_o(sl2addr)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcnormal),
        .data1_i(pcbranch),
        .select_i(c_branch & zero),
        .data_o(pcnew)
        );

MUX_2to1 #(.size(32)) Mux_WReg_Src(
        .data0_i(aluresult),
        .data1_i(memdata),
        .select_i(c_mtor),
        .data_o(wdata)
        );

endmodule
