module Hazard (
    pcsrc_i,
    memread_i,
    instr_id_i,
    instr_ex_i,
    pcwrite_o,
    id_flush_o,
    if_id_write_o
    );

input          pcsrc_i;
input          memread_i;
input [10-1:0] instr_id_i;
input [10-1:0] instr_ex_i;

output         pcwrite_o;
output         id_flush_o;
output         if_id_write_o;
reg            pcwrite_o;
reg            id_flush_o;
reg            if_id_write_o;

wire [5-1:0]   rs_id;
wire [5-1:0]   rt_id;
wire [5-1:0]   rt_ex;

assign rs_id = instr_id_i[9:5];
assign rt_id = instr_id_i[4:0];
assign rt_ex = instr_ex_i[4:0];

always @ ( * ) begin
    // Load-use hazard
    if(memread_i && ((rt_ex == rs_id) || (rt_ex == rt_id))) begin
        pcwrite_o <= 0;
        if_id_write_o <= 0;
        id_flush_o <= 1;
    end else begin
        pcwrite_o <= 1;
        if_id_write_o <= 1;
        id_flush_o <= 0;
    end
end

endmodule
