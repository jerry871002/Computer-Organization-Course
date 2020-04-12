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
always @ ( * ) begin
    case(ALUOp_i[2])
        1'b1: ALUCtrl_o <= { 2'b00, ALUOp_i[1:0] };
        1'b0: begin
            case(ALUOp_i[1:0])
                2'b11: ALUCtrl_o <= 4'b0110;
                default: begin
                    case(funct_i[5])
                        1'b1: begin
                            case(funct_i[4:0])
                                5'b00010: ALUCtrl_o <= 4'b0110;
                                5'b00100: ALUCtrl_o <= 4'b0000;
                                5'b00101: ALUCtrl_o <= 4'b0001;
                                5'b01010: ALUCtrl_o <= 4'b0111;
                                default: ALUCtrl_o <= 4'b0010;
                            endcase
                        end
                        1'b0: begin
                            case(funct_i[4:0])
                                5'b11000: ALUCtrl_o <= 4'b1011;
                                5'b01000: ALUCtrl_o <= 4'b0010;
                                default: ALUCtrl_o <= 4'b1111;
                            endcase
                        end
                    endcase
                end
            endcase
        end
    endcase
end

endmodule
