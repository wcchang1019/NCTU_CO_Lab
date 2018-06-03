//0516094 0516077
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
	rst_i
);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire[32-1:0] pc_IF;
wire[32-1:0] pc_new_IF;
wire[32-1:0] pc_next_IF;
wire[32-1:0] instr_IF;

/**** ID stage ****/
wire[32-1:0] pc_next_ID;
wire[32-1:0] instr_ID;

wire[32-1:0] RS_data_ID;
wire[32-1:0] RT_data_ID;
wire[32-1:0] SE_ID;

wire RegWrite_ID;
wire[3-1:0] ALUOp_ID;
wire ALUSrc_ID;
wire RegDst_ID;
wire Branch_ID;
wire Jump_ID;
wire MemRead_ID;
wire MemWrite_ID;
wire MemToReg_ID;
wire JalSelect_ID;
//control signal


/**** EX stage ****/
wire RegWrite_EX;
wire MemToReg_EX;
wire Branch_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire RegDst_EX;
wire[3-1:0] ALUOp_EX;
wire ALUSrc_EX;
wire[32-1:0] pc_next_EX;
wire[32-1:0] RS_data_EX;
wire[32-1:0] RT_data_EX;
wire[32-1:0] SE_EX;
wire[5-1:0] RT_addr_EX;
wire[5-1:0] RD_addr_EX;

wire[32-1:0] SL_EX;
wire zero_EX;
wire[32-1:0] ALU_result_EX;
wire[3:0] ALU_control_EX;
wire[5-1:0] write_addr_EX;
wire[32-1:0] ALU_in_EX;
wire[32-1:0] pc_back_EX;


//control signal


/**** MEM stage ****/
wire RegWrite_MEM;
wire MemToReg_MEM;
wire Branch_MEM;
wire MemRead_MEM;
wire MemWrite_MEM;
wire[32-1:0] pc_back_MEM;
wire zero_MEM;
wire[32-1:0] ALU_result_MEM;
wire[32-1:0] RT_data_MEM;
wire[5-1:0] write_addr_MEM;

wire[32-1:0] Mem_data_MEM;

//control signal


/**** WB stage ****/
wire RegWrite_WB;
wire MemToReg_WB;
wire[32-1:0] Mem_data_WB;
wire[32-1:0] ALU_result_WB;
wire[5-1:0] write_addr_WB;
wire[32-1:0] write_data_WB;

//control signal



/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(pc_next_IF),
	.data1_i(pc_back_MEM),
	.select_i(Branch_MEM & zero_MEM),
	.data_o(pc_new_IF)
);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(pc_new_IF),
	.pc_out_o(pc_IF)
);

Instruction_Memory IM(
	.addr_i(pc_IF),
	.instr_o(instr_IF)
);
			
Adder Add_pc(
	.src1_i(pc_IF),
	.src2_i(32'd4),
	.sum_o(pc_next_IF)
);

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({pc_next_IF,instr_IF}),
	.data_o({pc_next_ID,instr_ID})
);

		
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(instr_ID[25:21]),
	.RTaddr_i(instr_ID[20:16]),
	.RDaddr_i(write_addr_WB),
	.RDdata_i(write_data_WB),
	.RegWrite_i(RegWrite_WB),
	.RSdata_o(RS_data_ID),
	.RTdata_o(RT_data_ID)
);


Decoder Control(
	.instr_op_i(instr_ID[31:26]),
	.funct_i(instr_ID[5:0]),
	.RegWrite_o(RegWrite_ID),
	.ALU_op_o(ALUOp_ID),
	.ALUSrc_o(ALUSrc_ID),
	.RegDst_o(RegDst_ID),
	.Branch_o(Branch_ID),
	.Jump_o(Jump_ID),
	.MemRead_o(MemRead_ID),
	.MemWrite_o(MemWrite_ID),
	.MemToReg_o(MemToReg_ID),
	.JalSelect_o(JalSelect_ID)
);

Sign_Extend Sign_Extend(
	.data_i(instr_ID[15:0]),
	.data_o(SE_ID)
);	

Pipe_Reg #(.size(148)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({RegWrite_ID, MemToReg_ID, Branch_ID, MemRead_ID, MemWrite_ID, RegDst_ID, ALUOp_ID, ALUSrc_ID, pc_next_ID, RS_data_ID, RT_data_ID, SE_ID, instr_ID[20:16], instr_ID[15:11]}),
	.data_o({RegWrite_EX, MemToReg_EX, Branch_EX, MemRead_EX, MemWrite_EX, RegDst_EX, ALUOp_EX, ALUSrc_EX, pc_next_EX, RS_data_EX, RT_data_EX, SE_EX, RT_addr_EX, RD_addr_EX})
);
		
//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter(
	.data_i(SE_EX),
	.data_o(SL_EX)
);

ALU ALU(
	.src1_i(RS_data_EX),
	.src2_i(ALU_in_EX),
	.ctrl_i(ALU_control_EX),
	.result_o(ALU_result_EX),
	.zero_o(zero_EX)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(SE_EX[5:0]),
	.ALUOp_i(ALUOp_EX),
	.ALUCtrl_o(ALU_control_EX)
);

MUX_2to1 #(.size(5)) Mux1(
	.data0_i(RT_addr_EX),
	.data1_i(RD_addr_EX),
	.select_i(RegDst_EX),
	.data_o(write_addr_EX)
);

MUX_2to1 #(.size(32)) Mux2(
	.data0_i(RT_data_EX),
	.data1_i(SE_EX),
	.select_i(ALUSrc_EX),
	.data_o(ALU_in_EX)
);

Adder Add_pc_branch(
	.src1_i(pc_next_EX),     
	.src2_i(SL_EX),     
	.sum_o(pc_back_EX)      
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({RegWrite_EX, MemToReg_EX, Branch_EX, MemRead_EX, MemWrite_EX, pc_back_EX, zero_EX, ALU_result_EX, RT_data_EX, write_addr_EX}),
	.data_o({RegWrite_MEM, MemToReg_MEM, Branch_MEM, MemRead_MEM, MemWrite_MEM, pc_back_MEM, zero_MEM, ALU_result_MEM, RT_data_MEM, write_addr_MEM})
);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ALU_result_MEM),
	.data_i(RT_data_MEM),
	.MemRead_i(MemRead_MEM),
	.MemWrite_i(MemWrite_MEM),
	.data_o(Mem_data_MEM)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({RegWrite_MEM, MemToReg_MEM, Mem_data_MEM, ALU_result_MEM, write_addr_MEM}),
	.data_o({RegWrite_WB, MemToReg_WB, Mem_data_WB, ALU_result_WB, write_addr_WB})
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(ALU_result_WB),
	.data1_i(Mem_data_WB),
	.select_i(MemToReg_WB),
	.data_o(write_data_WB)
);

/****************************************
signal assignment
****************************************/	
endmodule
