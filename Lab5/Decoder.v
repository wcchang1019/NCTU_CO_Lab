//0516094 0516077
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
  	instr_op_i,
	funct_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,	
	MemRead_o,
	MemWrite_o,
	MemToReg_o,
	JalSelect_o	
	);
     
//I/O ports
input [6-1:0] instr_op_i;
input [6-1:0] funct_i;
output  RegWrite_o;
output [3-1:0] ALU_op_o;
output  ALUSrc_o;
output  RegDst_o;
output	Branch_o;
output 	MemToReg_o;
output	MemWrite_o;
output	MemRead_o;
output 	Jump_o;
output	JalSelect_o;

 
//Internal Signals
reg  	RegWrite_o;
reg [3-1:0] ALU_op_o;
reg  	ALUSrc_o;
reg  	RegDst_o;
reg	Branch_o;
reg 	MemToReg_o;
reg 	MemWrite_o;
reg 	MemRead_o;
reg 	Jump_o;
reg 	JalSelect_o;

always@(*) begin
    case (instr_op_i)
        6'b000000: begin	// R-type jr
				RegWrite_o <= (funct_i == 6'b001000)? 0 : 1;
				ALU_op_o <= 3'b100;	// 4
				ALUSrc_o <= 0;
				RegDst_o <= 1;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= (funct_i == 6'b001000)? 1 : 0;
				JalSelect_o <= 0;
		  end
        6'b001000: begin	// addi
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;	// 0
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
        6'b001010: begin	// slti
				RegWrite_o <= 1;
				ALU_op_o <= 3'b100;	
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
        6'b000100: begin 	// beq
				RegWrite_o <= 0;	
				ALU_op_o <= 3'b001;	// 1
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
        6'b000101: begin 	// bne
				RegWrite_o <= 0;	
				ALU_op_o <= 3'b101;	
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
        6'b000001: begin 	// bge
				RegWrite_o <= 0;	
				ALU_op_o <= 3'b110;	
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 1;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
        6'b000111: begin 	// bgt
				RegWrite_o <= 0;	
				ALU_op_o <= 3'b110;	
				ALUSrc_o <= 0;
				Branch_o <= 1;
				RegDst_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
		  6'b100011: begin	// lw
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;	// 
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 1;
				MemWrite_o <= 0;
				MemRead_o <= 1;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
		  6'b101011: begin	//sw
				RegWrite_o <= 0;
				ALU_op_o <= 3'b000;
				ALUSrc_o <= 1;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 1;
				MemRead_o <= 0;
				Jump_o <= 0;
				JalSelect_o <= 0;
		  end
		  6'b000010: begin	// jump
				RegWrite_o <= 0;
				ALU_op_o <= 3'b000;	
				ALUSrc_o <= 0;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 0;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 1;
				JalSelect_o <= 0;
		  end
		  6'b000011: begin	// jal
				RegWrite_o <= 1;
				ALU_op_o <= 3'b000;
				ALUSrc_o <= 0;
				RegDst_o <= 0;
				Branch_o <= 0;
				MemToReg_o <= 2'b00;
				MemWrite_o <= 0;
				MemRead_o <= 0;
				Jump_o <= 1;
				JalSelect_o <= 1;
		  end

    endcase
end


//Main function

endmodule





                    
                    