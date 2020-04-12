//0610780

//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation
always @( * ) begin
    if (ALUOp_i != 3'b011)
        ALUCtrl_o <= ALUOp_i;
    else begin
        case (funct_i)
            // MULT
            24: ALUCtrl_o <= 4;
            // ADD
            32: ALUCtrl_o <= 2;
            // SUB
            34: ALUCtrl_o <= 6;
            // AND
            36: ALUCtrl_o <= 0;
            // OR
            37: ALUCtrl_o <= 1;
            // SLT
            42: ALUCtrl_o <= 7;
            default: ALUCtrl_o <= 0;
        endcase
    end
end

endmodule
