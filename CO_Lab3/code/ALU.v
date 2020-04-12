// 0610780

//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);
always @ ( * ) begin
    case (ctrl_i)
        // And
        0: result_o <= src1_i & src2_i;
        // Or
        1: result_o <= src1_i | src2_i;
        // Add
        2: result_o <= src1_i + src2_i;
        // Subtract
        6: result_o <= src1_i - src2_i;
        // Set less than
        7: result_o <= (src1_i < src2_i) ? 1 : 0;
        default: result_o <= 0;
    endcase
end

endmodule
