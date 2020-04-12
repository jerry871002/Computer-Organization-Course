module Forwarding (
    wreg_mem_i,
    wreg_wb_i,
    rs_i,
    rt_i,
    regw_mem_i,
    regw_wb_i,
    forwardA_o,
    forwardB_o
    );


input        regw_mem_i;
input        regw_wb_i;
input [4:0]  wreg_mem_i;
input [4:0]  wreg_wb_i;
input [4:0]  rs_i;
input [4:0]  rt_i;

output [1:0] forwardA_o;
output [1:0] forwardB_o;

reg [1:0]    forwardA_o;
reg [1:0]    forwardB_o;

always @ ( * ) begin
    // FowardA
    // Ex hazard
    if (regw_mem_i && (wreg_mem_i != 0) && (wreg_mem_i == rs_i)) begin
        forwardA_o <= 2'b01;
    // MEM hazard
    end else if (regw_wb_i && (wreg_wb_i != 0) && (wreg_wb_i == rs_i)) begin
        forwardA_o <= 2'b10;
    // No hazard
    end else begin
        forwardA_o <= 2'b00;
    end

    // FowardB
    // Ex hazard
    if (regw_mem_i && (wreg_mem_i != 0) && (wreg_mem_i == rt_i)) begin
        forwardB_o <= 2'b01;
    // MEM hazard
    end else if (regw_wb_i && (wreg_wb_i != 0) && (wreg_wb_i == rt_i)) begin
        forwardB_o <= 2'b10;
    // No hazard
    end else begin
        forwardB_o <= 2'b00;
    end
end


endmodule
