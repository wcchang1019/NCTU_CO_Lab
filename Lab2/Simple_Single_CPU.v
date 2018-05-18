//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//0516094 0516077
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0]	pc_in;
wire [32-1:0]	pc_out;
wire [32-1:0]	pc_out_plus_4;

wire [6-1:0]	op_code;
wire [5-1:0]	rs_addr;
wire [5-1:0]	rt_addr;
wire [5-1:0]	rd_addr;
wire [5-1:0]	shamt;
wire [6-1:0]	funct;

wire	reg_dst;
wire [5-1:0]	write_reg_address;
wire [32-1:0]	write_data;
wire	reg_write;
wire	branch;
wire	alu_src;
wire [3-1:0]	alu_op;
wire [32-1:0]	rs_data;
wire [32-1:0]	rt_data;
wire [4-1:0]	alu_ctrl;
wire [32-1:0]	sign_extend_out;
wire [32-1:0]	mux_out;
wire	zero;
wire [32-1:0]	shift_two_out;
wire [32-1:0]	add_out;
wire	and_result;
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i (rst_i),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
);
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(pc_out_plus_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o({op_code,rs_addr,rt_addr,rd_addr,shamt,funct})    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt_addr),
        .data1_i(rd_addr),
        .select_i(reg_dst),
        .data_o(write_reg_address)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(rs_addr) ,  
        .RTaddr_i(rt_addr) ,  
        .RDaddr_i(write_reg_address) ,  
        .RDdata_i(write_data)  , 
        .RegWrite_i (reg_write),
        .RSdata_o(rs_data) ,  
        .RTdata_o(rt_data)   
        );
	
Decoder Decoder(
        .instr_op_i(op_code), 
	.RegWrite_o(reg_write), 
	.ALU_op_o(alu_op),   
	.ALUSrc_o(alu_src),   
	.RegDst_o(reg_dst),   
	.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(funct),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(alu_ctrl) 
        );
	
Sign_Extend SE(
        .data_i({rd_addr,shamt,funct}),
        .data_o(sign_extend_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rt_data),
        .data1_i(sign_extend_out),
        .select_i(alu_src),
        .data_o(mux_out)
        );	
		
ALU ALU(
        .src1_i(rs_data),
	.src2_i(mux_out),
	.ctrl_i(alu_ctrl),
	.result_o(write_data),
	.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(pc_out_plus_4),     
	.src2_i(shift_two_out),     
	.sum_o(add_out)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_extend_out),
        .data_o(shift_two_out)
        ); 		

and and_1 (and_result,zero,branch);

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_out_plus_4),
        .data1_i(add_out),
        .select_i(and_result),
        .data_o(pc_in)
        );	

endmodule
		  


