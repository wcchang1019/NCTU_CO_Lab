//0516094 0516077
module Hazard(
	PCSrc_i, 
	EX_MemRead_i, 
	ID_RSRT_i, 
	EX_RT_i,
	PCWrite_o, 
	IFID_o, 
	IFFlush_o, 
	IDFlush_o, 
	EXFlush_o
);
input PCSrc_i;
input EX_MemRead_i;
input [9:0] ID_RSRT_i;
input [4:0] EX_RT_i;
output PCWrite_o;
output IFID_o;
output IFFlush_o;
output IDFlush_o;
output EXFlush_o;

reg PCWrite_o;
reg IFID_o;
reg IFFlush_o;
reg IDFlush_o;
reg EXFlush_o;

always @(*) begin
	if (PCSrc_i == 1)  begin //branch
		PCWrite_o <= 1;
		IFID_o <= 0;
		IFFlush_o <= 1;
		IDFlush_o <= 1;
		EXFlush_o <= 1;
	end else if(EX_MemRead_i == 1 & ((EX_RT_i == ID_RSRT_i[9:5]) | (EX_RT_i == ID_RSRT_i[4:0]))) begin //hazard
		PCWrite_o <= 0;
		IFID_o <= 1;
		IFFlush_o <= 0;
		IDFlush_o <= 1;
		EXFlush_o <= 0;
	end else begin  // no hazard
			PCWrite_o <= 1;
			IFID_o <= 0;
			IFFlush_o <= 0;
			IDFlush_o <= 0;
			EXFlush_o <= 0;			
	end
end

endmodule