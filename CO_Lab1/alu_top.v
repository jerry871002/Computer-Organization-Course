`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:58:01 10/10/2013
// Design Name:
// Module Name:    alu_top
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

module alu_top(
              src1,       //1 bit source 1 (input)
              src2,       //1 bit source 2 (input)
              less,       //1 bit less     (input)
              A_invert,   //1 bit A_invert (input)
              B_invert,   //1 bit B_invert (input)
              cin,        //1 bit carry in (input)
              operation,  //operation      (input)
              result,     //1 bit result   (output)
              cout        //1 bit carry out(output)
              );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

wire          a_out;
wire          b_out;

reg           result;

assign a_out = (A_invert)? !src1: src1;
assign b_out = (B_invert)? !src2: src2;
assign cout = (a_out & b_out & ~cin) | (a_out & ~b_out & cin) | (~a_out & b_out & cin) | (a_out & b_out & cin);

always@(*)
begin
    case(operation[1:0])
        // AND
        2'b00: result = a_out & b_out;
        // OR
        2'b01: result = a_out | b_out;
        // ADD
        2'b10: result = a_out ^ b_out ^ cin;
        // LESS
        2'b11: result = less;
    endcase
end

endmodule
