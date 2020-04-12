// 0610780

`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );

/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_normal_if;
wire [31:0] pc_branch_if;
wire [31:0] pc_next;
wire [31:0] pc;
wire [31:0] instr_if;
//control signal
wire c_pcsrc;
/**** ID stage ****/
wire [31:0] pc_normal_id;
wire [31:0] instr_id;

wire [31:0] wdata;
wire [31:0] rdata1_id;
wire [31:0] rdata2_id;
wire [31:0] signext_id;
// control signal
wire c_regw_id;
wire c_mtor_id;
wire c_branch_id;
wire c_memr_id;
wire c_memw_id;
wire c_regdst_id;
wire [2:0] c_aluop_id;
wire c_alusrc_id;
/**** EX stage ****/
wire [31:0] pc_normal_ex;
wire [31:0] rdata1_ex;
wire [31:0] rdata2_ex;
wire [31:0] signext_ex;
wire [31:0] instr_ex;
wire [31:0] alu_src2;
wire [31:0] alu_result_ex;
wire [31:0] pc_branch_ex;
wire [4:0]  wreg_ex;
wire [31:0] signext_shift_ex;
// control signal
wire c_regw_ex;
wire c_mtor_ex;
wire c_branch_ex;
wire c_memr_ex;
wire c_memw_ex;
wire c_regdst_ex;
wire [2:0] c_aluop_ex;
wire c_alusrc_ex;
wire c_zero_ex;
wire [3:0] c_alu_ctrl;
/**** MEM stage ****/
wire [31:0] alu_result_mem;
wire [31:0] rdata2_mem;
wire [4:0]  wreg_mem;
wire [31:0] rdata_mem;
wire [31:0] pc_branch_mem;
// control signal
wire c_regw_mem;
wire c_mtor_mem;
wire c_branch_mem;
wire c_memr_mem;
wire c_memw_mem;
wire c_zero_mem;
/**** WB stage ****/
wire [31:0] rdata_wb;
wire [31:0] alu_result_wb;
wire [4:0]  wreg_wb;
// control signal
wire c_regw_wb;
wire c_mtor_wb;
/****************************************
Instantiate modules
****************************************/
// Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0 (
    .data0_i(pc_normal_if),
	.data1_i(pc_branch_mem),
	.select_i(c_pcsrc),
	.data_o(pc_next)
);

ProgramCounter PC (
    .clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc_next),
	.pc_out_o(pc)
);

Instruction_Memory IM (
    .addr_i(pc),
	.instr_o(instr_if)
);

Adder Add_pc (
    .src1_i(32'd4),
	.src2_i(pc),
	.sum_o(pc_normal_if)
);

// N is the total length of input/output
Pipe_Reg #(.size(64)) IF_ID (
    .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({pc_normal_if, instr_if}),
	.data_o({pc_normal_id, instr_id})
);

// Instantiate the components in ID stage
Reg_File RF (
    .clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(instr_id[25:21]),
	.RTaddr_i(instr_id[20:16]),
	.RDaddr_i(wreg_wb),
	.RDdata_i(wdata),
	.RegWrite_i(c_regw_wb),
	.RSdata_o(rdata1_id),
	.RTdata_o(rdata2_id)
);

Decoder Control (
    .instr_op_i(instr_id[31:26]),
	.RegWrite_o(c_regw_id),
	.ALU_op_o(c_aluop_id),
	.ALUSrc_o(c_alusrc_id),
	.RegDst_o(c_regdst_id),
	.Branch_o(c_branch_id),
	.MemToReg_o(c_mtor_id),
	.MemRead_o(c_memr_id),
	.MemWrite_o(c_memw_id)
);

Sign_Extend Sign_Extend (
    .data_i(instr_id[15:0]),
	.data_o(signext_id)
);

Pipe_Reg #(.size(170)) ID_EX (
    .clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({c_regw_id, c_mtor_id, c_branch_id,
             c_memr_id, c_memw_id, c_regdst_id,
             c_aluop_id, c_alusrc_id,
             pc_normal_id, rdata1_id, rdata2_id,
             signext_id, instr_id}),
    .data_o({c_regw_ex, c_mtor_ex, c_branch_ex,
             c_memr_ex, c_memw_ex, c_regdst_ex,
             c_aluop_ex, c_alusrc_ex,
             pc_normal_ex, rdata1_ex, rdata2_ex,
             signext_ex, instr_ex})
);

// Instantiate the components in EX stage
Shift_Left_Two_32 Shifter (
    .data_i(signext_ex),
	.data_o(signext_shift_ex)
);

ALU ALU (
    .src1_i(rdata1_ex),
	.src2_i(alu_src2),
	.ctrl_i(c_alu_ctrl),
	.result_o(alu_result_ex),
	.zero_o(c_zero_ex)
);

ALU_Ctrl ALU_Control (
    .funct_i(instr_ex[5:0]),
	.ALUOp_i(c_aluop_ex),
	.ALUCtrl_o(c_alu_ctrl)
);

MUX_2to1 #(.size(32)) Mux1 (
    .data0_i(rdata2_ex),
	.data1_i(signext_ex),
	.select_i(c_alusrc_ex),
	.data_o(alu_src2)
);

MUX_2to1 #(.size(5)) Mux2 (
    .data0_i(instr_ex[20:16]),
	.data1_i(instr_ex[15:11]),
	.select_i(c_regdst_ex),
	.data_o(wreg_ex)
);

Adder Add_pc_branch (
    .src1_i(pc_normal_ex),
	.src2_i(signext_shift_ex),
	.sum_o(pc_branch_ex)
);

Pipe_Reg #(.size(107)) EX_MEM (
    .clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({c_regw_ex, c_mtor_ex, c_branch_ex,
             c_memr_ex, c_memw_ex, c_zero_ex,
             pc_branch_ex, alu_result_ex,
             rdata2_ex, wreg_ex}),
    .data_o({c_regw_mem, c_mtor_mem, c_branch_mem,
             c_memr_mem, c_memw_mem, c_zero_mem,
             pc_branch_mem, alu_result_mem,
             rdata2_mem, wreg_mem})
);

// Instantiate the components in MEM stage
Data_Memory DM (
    .clk_i(clk_i),
	.addr_i(alu_result_mem),
	.data_i(rdata2_mem),
	.MemRead_i(c_memr_mem),
	.MemWrite_i(c_memw_mem),
	.data_o(rdata_mem)
);

Pipe_Reg #(.size(71)) MEM_WB (
    .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({c_regw_mem, c_mtor_mem,
             rdata_mem, alu_result_mem, wreg_mem}),
	.data_o({c_regw_wb, c_mtor_wb,
             rdata_wb, alu_result_wb, wreg_wb})
);

// Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3 (
    .data0_i(alu_result_wb),
	.data1_i(rdata_wb),
	.select_i(c_mtor_wb),
	.data_o(wdata)
);

/****************************************
signal assignment
****************************************/

assign c_pcsrc = c_branch_mem && c_zero_mem;

endmodule
