//0516094 0516077
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
module Simple_Single_CPU(
        clk_i,
    rst_i
);
        
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0]  pc_next_ins;
wire [31:0]  pc;
wire [31:0]  pc_back_pre;
wire [31:0] pc_back;
wire [31:0] pc1;
wire [31:0]  instr;
wire [5-1:0] Write_Reg1;
wire [31:0] RS_data;
wire [31:0] RT_data;
wire [3-1:0]    ALU_op;
wire           ALUSrc;
wire           RegWrite;
wire           RegDst;
wire           Branch;
wire           Jump;
wire           MemRead;
wire    MemWrite;
wire    MemtoReg;
wire [2-1:0]    Branch_type;
wire        jal;
wire [4:0]  jal_result;
wire [31:0] wdata;
wire [4-1:0] ALUCtrl;
wire [31:0] SE_out;
wire [31:0] ALU_in;
wire [31:0] ALU_result;
wire zero;
wire [31:0] SL_out;
wire [31:0] Mem_out;
wire [31:0] jal_addr;
wire    zero2;
wire [31:0] top_shift;
wire jr;
wire [31:0] jr_result;
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_back),   
        .pc_out_o(pc) 
        );
    
Adder Adder1(
        .src1_i(32'd4),     
        .src2_i(pc),     
        .sum_o(pc_next_ins)    
        );
    
Instr_Memory IM(
        .pc_addr_i(pc),  
        .instr_o(instr)    
        );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(Write_Reg1)
        );  
        
Reg_File Registers(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(jal_result),  
        .RDdata_i(wdata) , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RS_data) ,  
        .RTdata_o(RT_data)   
        );



Decoder Decoder(
    .instr_op_i(instr[31:26]),
    .funct_i(instr[5:0]),
    .RegWrite_o(RegWrite),
    .ALU_op_o(ALU_op),
    .ALUSrc_o(ALUSrc),
    .RegDst_o(RegDst),
    .Branch_o(Branch),
    .Jump_o(Jump),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite),
    .MemToReg_o(MemtoReg),
    .JalSelect_o(jal)  
);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
    
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(SE_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RT_data),
        .data1_i(SE_out),
        .select_i(ALUSrc),
        .data_o(ALU_in)
        );  
        
ALU ALU(
        .src1_i(RS_data),
        .src2_i(ALU_in),
        .ctrl_i(ALUCtrl),
        .result_o(ALU_result),
        .zero_o(zero)
        );
    

    
Adder Adder2(
        .src1_i(pc_next_ins),     
        .src2_i(SL_out),     
        .sum_o(pc_back_pre)      
        );
        
Shift_Left_Two_32 Shifter(
        .data_i(SE_out),
        .data_o(SL_out)
        );  



MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next_ins),
        .data1_i(pc_back_pre),
        .select_i(Branch & zero),
        .data_o(pc1)
        );

Shift_Left_Two_32 Top_shift(
          .data_i({6'b000000,instr[25:0]}),
          .data_o(top_shift)
    );

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(ALU_result),
    .data_i(RT_data),
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite),
    .data_o(Mem_out)
    );

MUX_3to1 #(.size(32)) Mux_Read_data(
        .data0_i(jal_addr),
    .data1_i(Mem_out),
        .data2_i(SE_out),
        .select_i(MemtoReg),
        .data_o(wdata)
        );

MUX_2to1 #(.size(32)) Jump_Mux(
    .data0_i(pc1),
        .data1_i(jr_result),
        .select_i(Jump),
        .data_o(pc_back)
        );

MUX_2to1 #(.size(32)) Mux_jal_addr(
        .data0_i(ALU_result),
        .data1_i(pc_next_ins),
        .select_i(jal),
        .data_o(jal_addr)
        );

MUX_2to1 #(.size(32)) Mux_jr(
        .data0_i({pc_next_ins[31:28],top_shift[27:0]}),
        .data1_i(RS_data),
        .select_i(jr),
        .data_o(jr_result)
        );

MUX_2to1 #(.size(5)) Mux_jal_reg(
        .data0_i(Write_Reg1),
        .data1_i(5'd31),
        .select_i(jal),
        .data_o(jal_result)
);

assign Jump = ({instr[31:26], instr[5:0]} == {6'b000000, 6'b001000})? 1 :
                  (instr[31:26] == 6'b000010) ? 1 :
                  (instr[31:26] == 6'b000011)? 1: 
                  0;
assign jr = ({instr[31:26], instr[5:0]} == {6'b000000, 6'b001000})? 1: 0; 
endmodule
          
