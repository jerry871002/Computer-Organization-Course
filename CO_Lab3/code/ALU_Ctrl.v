// 0610780

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
          ALUCtrl_o,
          BonusCtrl_o,
          ALUShift_o
          );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
output     [3-1:0] BonusCtrl_o;
output             ALUShift_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg        [3-1:0] BonusCtrl_o;
reg                ALUShift_o;

//Parameter

//Select exact operation
always @ ( * ) begin
    case(ALUOp_i[2])
        1'b1: begin
            ALUCtrl_o   <= { 2'b00, ALUOp_i[1:0] };
            BonusCtrl_o <= 3'b000;
            ALUShift_o  <= 0;
        end
        1'b0: begin
            case(ALUOp_i[1:0])
                2'b11: begin
                    ALUCtrl_o   <= 4'b0110;
                    BonusCtrl_o <= 3'b000;
                    ALUShift_o  <= 0;
                end
                default: begin
                    case(funct_i[5])
                        1'b1: begin
                            case(funct_i[4:0])
                                5'b00010: ALUCtrl_o <= 4'b0110;
                                5'b00100: ALUCtrl_o <= 4'b0000;
                                5'b00101: ALUCtrl_o <= 4'b0001;
                                5'b01010: ALUCtrl_o <= 4'b0111;
                                default: ALUCtrl_o  <= 4'b0010;
                            endcase
                            BonusCtrl_o <= 3'b000;
                            ALUShift_o  <= 1'b0;
                        end
                        1'b0: begin
                            case(funct_i[4:0])
                                5'b11000: begin
                                    ALUCtrl_o   <= 4'b1011;
                                    BonusCtrl_o <= 3'b000;
                                end
                                5'b01000: begin
                                    ALUCtrl_o   <= 4'b0010;
                                    BonusCtrl_o <= 3'b010;
                                end
                                default: begin
                                    ALUCtrl_o   <= 4'b1111;
                                    BonusCtrl_o <= funct_i[1] ==1'b1 ? 3'b101 : 3'b000;
                                end
                            endcase
                            ALUShift_o <= ~(funct_i[4] & funct_i[3]) & ~funct_i[2];
                        end
                    endcase
                end
            endcase
        end
    endcase
end

endmodule
