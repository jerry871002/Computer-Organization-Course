//0610780

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
    MemToReg_o,
    MemRead_o,
    MemWrite_o
	);

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemToReg_o;
output         MemRead_o;
output         MemWrite_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemToReg_o;
reg            MemRead_o;
reg            MemWrite_o;
//Parameter


//Main function
always @( * ) begin
    RegWrite_o = (instr_op_i == 0 || // R-type
                  instr_op_i == 3 || // jal
                  instr_op_i == 8 || // addi
                  instr_op_i == 10 || // slti
                  instr_op_i == 35); // lw

    ALUSrc_o = (instr_op_i == 8 || // addi
                instr_op_i == 10 || //slti
                instr_op_i == 35 || // lw
                instr_op_i == 43); // sw

    case (instr_op_i)
        4:  ALU_op_o <= 6; // beq -> sub
        8:  ALU_op_o <= 2; // addi -> add
        10: ALU_op_o <= 7; // alti -> slt
        35: ALU_op_o <= 2; // lw -> add
        43: ALU_op_o <= 2; // sw -> add
        default: ALU_op_o = 3; // R-type included
    endcase

    RegDst_o <= (instr_op_i == 0); // R-type
    Branch_o <= (instr_op_i == 4); // beq
    MemToReg_o <= (instr_op_i == 35); // lw
    MemRead_o <= (instr_op_i == 35); // lw
    MemWrite_o <= (instr_op_i == 43); // sw
    end
endmodule
