// 0610780

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
wire [31:0] pc, pci, pcx, pco, pcnormal, pcbranch;
wire [31:0] instr;
wire        c_regw, c_alusrc, c_branch, c_alush, c_jump, c_memr, c_memw;
wire [1:0]  c_mtor, c_regd;
wire [2:0]  c_aluop;
wire [2:0]  bonusctrl;
wire [3:0]  aluctrl;
wire [4:0]  regtow;
wire [31:0] rdata1, rdata2, mdata;
wire [31:0] signext;
wire [31:0] sl2data;
wire [31:0] src1, src2, aluresult, wdata;
wire        zero;
//Create componentes

ProgramCounter PC(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_in_i(pc),
        .pc_out_o(pco)
        );

Adder Adder1(
        .src1_i(32'd4),
        .src2_i(pco),
        .sum_o(pcnormal)
        );

Instr_Memory IM(
        .pc_addr_i(pco),
        .instr_o(instr)
        );

MUX_4to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
        .data3_i(5'd31),
        .select_i(c_regd),
        .data_o(regtow)
        );

Reg_File Registers(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(regtow),
        .RDdata_i(wdata),
        .RegWrite_i(c_regw),
        .RSdata_o(rdata1),
        .RTdata_o(rdata2)
        );

Decoder Decoder(
        .instr_op_i(instr[31:26]),
        .RegWrite_o(c_regw),
        .ALU_op_o(c_aluop),
        .ALUSrc_o(c_alusrc),
        .RegDst_o(c_regd),
        .Branch_o(c_branch),
        .Jump_o(c_jump),
        .MemRead_o(c_memr),
        .MemWrite_o(c_memw),
        .MemtoReg_o(c_mtor)
        );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),
        .ALUOp_i(c_aluop),
        .ALUCtrl_o(aluctrl),
        .BonusCtrl_o(bonusctrl),
        .ALUShift_o(c_alush)
        );

Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(signext)
        );

MUX_2to1 #(.size(32)) Mux_Src1(
        .data0_i(rdata1),
        .data1_i({ 27'd0, instr[10:6] }),
        .select_i(c_alush),
        .data_o(src1)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rdata2),
        .data1_i(signext),
        .select_i(c_alusrc),
        .data_o(src2)
        );

ALU ALU(
        .src1_i(src1),
        .src2_i(src2),
        .ctrl_i(aluctrl),
        .result_o(aluresult),
        .zero_o(zero)
        );

MUX_4to1 #(.size(32)) Mux_WReg_Src(
        .data0_i(aluresult),
        .data1_i(mdata),
        .data2_i(signext),
        .data3_i(pcnormal),
        .select_i(c_mtor),
        .data_o(wdata)
        );

Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(aluresult),
        .data_i(rdata2),
        .MemRead_i(c_memr),
        .MemWrite_i(c_memw),
        .data_o(mdata)
        );

Adder Adder2(
        .src1_i(pcnormal),
        .src2_i(sl2data),
        .sum_o(pcbranch)
        );

Shift_Left_Two_32 Shifter(
        .data_i(signext),
        .data_o(sl2data)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcnormal),
        .data1_i(pcbranch),
        .select_i(c_branch & zero),
        .data_o(pcx)
        );

MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(pcx),
        .data1_i({ pcnormal[31:28], instr[25:0], 2'b00 }),
        .select_i(c_jump),
        .data_o(pci)
        );

MUX_2to1 #(.size(32)) Mux_Return(
        .data0_i(pci),
        .data1_i(rdata1),
        .select_i(bonusctrl[1]),
        .data_o(pc)
        );

endmodule
