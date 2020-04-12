`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire   [32-1:0] result_temp;
wire            zero_temp;
wire            cout_temp;
wire            overflow_temp;
wire            set;
wire   [31-1:0] carry;

alu_top bit_0 (src1[0],  src2[0],  set,  ALU_control[3], ALU_control[2], ALU_control[2], ALU_control[1:0], result_temp[0], carry[0]);
alu_top bit_1 (src1[1],  src2[1],  1'b0, ALU_control[3], ALU_control[2], carry[0],  ALU_control[1:0], result_temp[1],  carry[1]);
alu_top bit_2 (src1[2],  src2[2],  1'b0, ALU_control[3], ALU_control[2], carry[1],  ALU_control[1:0], result_temp[2],  carry[2]);
alu_top bit_3 (src1[3],  src2[3],  1'b0, ALU_control[3], ALU_control[2], carry[2],  ALU_control[1:0], result_temp[3],  carry[3]);
alu_top bit_4 (src1[4],  src2[4],  1'b0, ALU_control[3], ALU_control[2], carry[3],  ALU_control[1:0], result_temp[4],  carry[4]);
alu_top bit_5 (src1[5],  src2[5],  1'b0, ALU_control[3], ALU_control[2], carry[4],  ALU_control[1:0], result_temp[5],  carry[5]);
alu_top bit_6 (src1[6],  src2[6],  1'b0, ALU_control[3], ALU_control[2], carry[5],  ALU_control[1:0], result_temp[6],  carry[6]);
alu_top bit_7 (src1[7],  src2[7],  1'b0, ALU_control[3], ALU_control[2], carry[6],  ALU_control[1:0], result_temp[7],  carry[7]);
alu_top bit_8 (src1[8],  src2[8],  1'b0, ALU_control[3], ALU_control[2], carry[7],  ALU_control[1:0], result_temp[8],  carry[8]);
alu_top bit_9 (src1[9],  src2[9],  1'b0, ALU_control[3], ALU_control[2], carry[8],  ALU_control[1:0], result_temp[9],  carry[9]);
alu_top bit_10(src1[10], src2[10], 1'b0, ALU_control[3], ALU_control[2], carry[9],  ALU_control[1:0], result_temp[10], carry[10]);
alu_top bit_11(src1[11], src2[11], 1'b0, ALU_control[3], ALU_control[2], carry[10], ALU_control[1:0], result_temp[11], carry[11]);
alu_top bit_12(src1[12], src2[12], 1'b0, ALU_control[3], ALU_control[2], carry[11], ALU_control[1:0], result_temp[12], carry[12]);
alu_top bit_13(src1[13], src2[13], 1'b0, ALU_control[3], ALU_control[2], carry[12], ALU_control[1:0], result_temp[13], carry[13]);
alu_top bit_14(src1[14], src2[14], 1'b0, ALU_control[3], ALU_control[2], carry[13], ALU_control[1:0], result_temp[14], carry[14]);
alu_top bit_15(src1[15], src2[15], 1'b0, ALU_control[3], ALU_control[2], carry[14], ALU_control[1:0], result_temp[15], carry[15]);
alu_top bit_16(src1[16], src2[16], 1'b0, ALU_control[3], ALU_control[2], carry[15], ALU_control[1:0], result_temp[16], carry[16]);
alu_top bit_17(src1[17], src2[17], 1'b0, ALU_control[3], ALU_control[2], carry[16], ALU_control[1:0], result_temp[17], carry[17]);
alu_top bit_18(src1[18], src2[18], 1'b0, ALU_control[3], ALU_control[2], carry[17], ALU_control[1:0], result_temp[18], carry[18]);
alu_top bit_19(src1[19], src2[19], 1'b0, ALU_control[3], ALU_control[2], carry[18], ALU_control[1:0], result_temp[19], carry[19]);
alu_top bit_20(src1[20], src2[20], 1'b0, ALU_control[3], ALU_control[2], carry[19], ALU_control[1:0], result_temp[20], carry[20]);
alu_top bit_21(src1[21], src2[21], 1'b0, ALU_control[3], ALU_control[2], carry[20], ALU_control[1:0], result_temp[21], carry[21]);
alu_top bit_22(src1[22], src2[22], 1'b0, ALU_control[3], ALU_control[2], carry[21], ALU_control[1:0], result_temp[22], carry[22]);
alu_top bit_23(src1[23], src2[23], 1'b0, ALU_control[3], ALU_control[2], carry[22], ALU_control[1:0], result_temp[23], carry[23]);
alu_top bit_24(src1[24], src2[24], 1'b0, ALU_control[3], ALU_control[2], carry[23], ALU_control[1:0], result_temp[24], carry[24]);
alu_top bit_25(src1[25], src2[25], 1'b0, ALU_control[3], ALU_control[2], carry[24], ALU_control[1:0], result_temp[25], carry[25]);
alu_top bit_26(src1[26], src2[26], 1'b0, ALU_control[3], ALU_control[2], carry[25], ALU_control[1:0], result_temp[26], carry[26]);
alu_top bit_27(src1[27], src2[27], 1'b0, ALU_control[3], ALU_control[2], carry[26], ALU_control[1:0], result_temp[27], carry[27]);
alu_top bit_28(src1[28], src2[28], 1'b0, ALU_control[3], ALU_control[2], carry[27], ALU_control[1:0], result_temp[28], carry[28]);
alu_top bit_29(src1[29], src2[29], 1'b0, ALU_control[3], ALU_control[2], carry[28], ALU_control[1:0], result_temp[29], carry[29]);
alu_top bit_30(src1[30], src2[30], 1'b0, ALU_control[3], ALU_control[2], carry[29], ALU_control[1:0], result_temp[30], carry[30]);
alu_msb bit_31(src1[31], src2[31], 1'b0, ALU_control[3], ALU_control[2], carry[30], ALU_control[1:0], result_temp[31], cout_temp, set, overflow_temp);

assign zero_temp = ~(result_temp[0]  | result_temp[1]  | result_temp[2]  | result_temp[3]  | result_temp[4]  |
                     result_temp[5]  | result_temp[6]  | result_temp[7]  | result_temp[8]  | result_temp[9]  |
                     result_temp[10] | result_temp[11] | result_temp[12] | result_temp[13] | result_temp[14] |
                     result_temp[15] | result_temp[16] | result_temp[17] | result_temp[18] | result_temp[19] |
                     result_temp[20] | result_temp[21] | result_temp[22] | result_temp[23] | result_temp[24] |
                     result_temp[25] | result_temp[26] | result_temp[27] | result_temp[28] | result_temp[29] |
                     result_temp[30] | result_temp[31]);

always@( posedge clk or negedge rst_n )
begin
	if(!rst_n) begin
        result[31:0] <= 0;
        cout <= 0;
        overflow <= 0;
        zero <= 0;
	end
	else begin
		result[31:0] <= result_temp[31:0];
		cout <= cout_temp;
		overflow <= overflow_temp;
		zero <= zero_temp;
	end
end

endmodule
