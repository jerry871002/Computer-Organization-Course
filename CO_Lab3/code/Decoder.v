// 0610780

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
    Jump_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o,
    );

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;
output         Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [2-1:0] MemtoReg_o;

//Internal Signals
reg         ALUSrc_o;

reg  [14:0] controls_o;

assign { RegWrite_o, ALU_op_o, RegDst_o, Branch_o,
         Jump_o, MemRead_o, MemWrite_o, MemtoReg_o } = controls_o;

// Main Function
always @ ( * ) begin
    ALUSrc_o <= instr_op_i[3] | instr_op_i[5];

    case(instr_op_i)
        6'b000011: controls_o <= 12'b1_011_10_0_1_0_0_11;    // jal
        6'b100011: controls_o <= 12'b1_110_00_0_0_1_0_01;    // lw
        6'b101011: controls_o <= 12'b0_110_00_0_0_0_1_00;    // sw
        6'b000010: controls_o <= 12'b0_011_01_0_1_0_0_00;    // jump
        6'b000100: controls_o <= 12'b0_011_01_1_0_0_0_00;    // beq
        6'b001000: controls_o <= 12'b1_110_00_0_0_0_0_00;    // addi
        default:   controls_o <= 12'b1_000_01_0_0_0_0_00;    // R-type
    endcase
end


endmodule
