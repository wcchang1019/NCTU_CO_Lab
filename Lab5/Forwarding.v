//0516094 0516077
module Forwarding(
    EX_RS_i,
    EX_RT_i,
    MEM_RD_i,
    MEM_RegWrite,
    WB_RD_i,
    WB_RegWrite,
    Forwarding_1_o,
    Forwarding_2_o
    );

//I/O ports
input	[5-1:0] EX_RS_i;
input	[5-1:0] EX_RT_i;
input	[5-1:0] MEM_RD_i;
input	[5-1:0] WB_RD_i;
input 	MEM_RegWrite;
input 	WB_RegWrite;
output	[2-1:0] Forwarding_1_o;
output	[2-1:0] Forwarding_2_o;

reg 	[2-1:0] Forwarding_1_o;
reg 	[2-1:0] Forwarding_2_o;

//Forwarding Conditions
always @ (*) begin
	if(WB_RegWrite & WB_RD_i!=0 & !(MEM_RegWrite & MEM_RD_i!=0 & MEM_RD_i==EX_RS_i) & WB_RD_i==EX_RS_i) 
		Forwarding_1_o = 2'b10;
	else if(MEM_RegWrite & MEM_RD_i!=0 & MEM_RD_i==EX_RS_i) 
		Forwarding_1_o = 2'b01;
	else 
		Forwarding_1_o = 2'b00;
	
	if(WB_RegWrite & WB_RD_i!=0 & !(MEM_RegWrite & MEM_RD_i!=0 & MEM_RD_i==EX_RT_i) & WB_RD_i==EX_RT_i) 
		Forwarding_2_o = 2'b10;
	else if(MEM_RegWrite & MEM_RD_i!=0 & MEM_RD_i==EX_RT_i) 
		Forwarding_2_o = 2'b01;
	else 
		Forwarding_2_o = 2'b00;
end
endmodule