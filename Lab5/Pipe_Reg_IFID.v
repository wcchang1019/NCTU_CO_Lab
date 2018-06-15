//0516094 0516077
module Pipe_Reg_IFID(
	clk_i,
	rst_i,
	data_i,
	IFID_i,
	IF_Flush_i,
	data_o
);
parameter size = 0;

input clk_i;
input rst_i;
input [size-1:0] data_i;
input IFID_i;
input IF_Flush_i;
output reg [size-1:0] data_o;

always@(posedge clk_i) begin
    if(~rst_i || IF_Flush_i == 1'b1)
        data_o <= 0;
    else if(IFID_i == 1'b1)
	data_o <= data_o;
    else
        data_o <= data_i;
end

endmodule	