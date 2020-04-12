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

module alu_msb(
              src1,       //1 bit source 1 (input)
              src2,       //1 bit source 2 (input)
              less,       //1 bit less     (input)
              A_invert,   //1 bit A_invert (input)
              B_invert,   //1 bit B_invert (input)
              cin,        //1 bit carry in (input)
              operation,  //operation      (input)
              result,     //1 bit result   (output)
              cout,       //1 bit carry out(output)
              set,        //1 bit set(output)
              overflow    //1 bit overflow(output)
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
output        set;
output        overflow;

wire          a_out;
wire          b_out;

reg           result;
reg           overflow;
reg           cout;

assign a_out = (A_invert)? !src1: src1;
assign b_out = (B_invert)? !src2: src2;
assign set = a_out ^ b_out ^ cin;

always@(*)
begin
    case(operation[1:0])
        2'b00: begin // AND
            result = a_out & b_out;
            cout = 0;
            overflow = 0;
        end
        2'b01: begin // OR
            result = a_out | b_out;
            cout = 0;
            overflow = 0;
        end
        2'b10: begin // ADD
            result = a_out ^ b_out ^ cin;
            cout = (a_out & b_out & ~cin) | (a_out & ~b_out & cin) | (~a_out & b_out & cin) | (a_out & b_out & cin);
            overflow = cin ^ cout;
        end
        2'b11: begin // LESS
            result = less;
            cout = 0;
            overflow = 0;
        end
    endcase
end

endmodule
