`timescale 1ns/1ps
//0516094 0516077
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
wire   [32-1:0] resulttmp;
wire   [32-1:0] couttmp;
wire 		set;
wire            less;
wire            zro;
wire		overfl;
wire            sign;
wire             cin;
assign less=1'b0;
assign cin = (ALU_control==4'b0110 | ALU_control==4'b0111)? 1 : 0;

alu_top alu_0(src1[0],src2[0],set,ALU_control[3],ALU_control[2],cin,ALU_control[1:0],resulttmp[0],couttmp[0]);
alu_top alu_1(src1[1],src2[1],less,ALU_control[3],ALU_control[2],couttmp[0],ALU_control[1:0],resulttmp[1],couttmp[1]);
alu_top alu_2(src1[2],src2[2],less,ALU_control[3],ALU_control[2],couttmp[1],ALU_control[1:0],resulttmp[2],couttmp[2]);
alu_top alu_3(src1[3],src2[3],less,ALU_control[3],ALU_control[2],couttmp[2],ALU_control[1:0],resulttmp[3],couttmp[3]);
alu_top alu_4(src1[4],src2[4],less,ALU_control[3],ALU_control[2],couttmp[3],ALU_control[1:0],resulttmp[4],couttmp[4]);
alu_top alu_5(src1[5],src2[5],less,ALU_control[3],ALU_control[2],couttmp[4],ALU_control[1:0],resulttmp[5],couttmp[5]);
alu_top alu_6(src1[6],src2[6],less,ALU_control[3],ALU_control[2],couttmp[5],ALU_control[1:0],resulttmp[6],couttmp[6]);
alu_top alu_7(src1[7],src2[7],less,ALU_control[3],ALU_control[2],couttmp[6],ALU_control[1:0],resulttmp[7],couttmp[7]);
alu_top alu_8(src1[8],src2[8],less,ALU_control[3],ALU_control[2],couttmp[7],ALU_control[1:0],resulttmp[8],couttmp[8]);
alu_top alu_9(src1[9],src2[9],less,ALU_control[3],ALU_control[2],couttmp[8],ALU_control[1:0],resulttmp[9],couttmp[9]);
alu_top alu_10(src1[10],src2[10],less,ALU_control[3],ALU_control[2],couttmp[9],ALU_control[1:0],resulttmp[10],couttmp[10]);
alu_top alu_11(src1[11],src2[11],less,ALU_control[3],ALU_control[2],couttmp[10],ALU_control[1:0],resulttmp[11],couttmp[11]);
alu_top alu_12(src1[12],src2[12],less,ALU_control[3],ALU_control[2],couttmp[11],ALU_control[1:0],resulttmp[12],couttmp[12]);
alu_top alu_13(src1[13],src2[13],less,ALU_control[3],ALU_control[2],couttmp[12],ALU_control[1:0],resulttmp[13],couttmp[13]);
alu_top alu_14(src1[14],src2[14],less,ALU_control[3],ALU_control[2],couttmp[13],ALU_control[1:0],resulttmp[14],couttmp[14]);
alu_top alu_15(src1[15],src2[15],less,ALU_control[3],ALU_control[2],couttmp[14],ALU_control[1:0],resulttmp[15],couttmp[15]);
alu_top alu_16(src1[16],src2[16],less,ALU_control[3],ALU_control[2],couttmp[15],ALU_control[1:0],resulttmp[16],couttmp[16]);
alu_top alu_17(src1[17],src2[17],less,ALU_control[3],ALU_control[2],couttmp[16],ALU_control[1:0],resulttmp[17],couttmp[17]);
alu_top alu_18(src1[18],src2[18],less,ALU_control[3],ALU_control[2],couttmp[17],ALU_control[1:0],resulttmp[18],couttmp[18]);
alu_top alu_19(src1[19],src2[19],less,ALU_control[3],ALU_control[2],couttmp[18],ALU_control[1:0],resulttmp[19],couttmp[19]);
alu_top alu_20(src1[20],src2[20],less,ALU_control[3],ALU_control[2],couttmp[19],ALU_control[1:0],resulttmp[20],couttmp[20]);
alu_top alu_21(src1[21],src2[21],less,ALU_control[3],ALU_control[2],couttmp[20],ALU_control[1:0],resulttmp[21],couttmp[21]);
alu_top alu_22(src1[22],src2[22],less,ALU_control[3],ALU_control[2],couttmp[21],ALU_control[1:0],resulttmp[22],couttmp[22]);
alu_top alu_23(src1[23],src2[23],less,ALU_control[3],ALU_control[2],couttmp[22],ALU_control[1:0],resulttmp[23],couttmp[23]);
alu_top alu_24(src1[24],src2[24],less,ALU_control[3],ALU_control[2],couttmp[23],ALU_control[1:0],resulttmp[24],couttmp[24]);
alu_top alu_25(src1[25],src2[25],less,ALU_control[3],ALU_control[2],couttmp[24],ALU_control[1:0],resulttmp[25],couttmp[25]);
alu_top alu_26(src1[26],src2[26],less,ALU_control[3],ALU_control[2],couttmp[25],ALU_control[1:0],resulttmp[26],couttmp[26]);
alu_top alu_27(src1[27],src2[27],less,ALU_control[3],ALU_control[2],couttmp[26],ALU_control[1:0],resulttmp[27],couttmp[27]);
alu_top alu_28(src1[28],src2[28],less,ALU_control[3],ALU_control[2],couttmp[27],ALU_control[1:0],resulttmp[28],couttmp[28]);
alu_top alu_29(src1[29],src2[29],less,ALU_control[3],ALU_control[2],couttmp[28],ALU_control[1:0],resulttmp[29],couttmp[29]);
alu_top alu_30(src1[30],src2[30],less,ALU_control[3],ALU_control[2],couttmp[29],ALU_control[1:0],resulttmp[30],couttmp[30]);
alu_top alu_31(src1[31],src2[31],less,ALU_control[3],ALU_control[2],couttmp[30],ALU_control[1:0],resulttmp[31],couttmp[31]);

nor n1(zro,resulttmp[0],resulttmp[1],resulttmp[2],resulttmp[3],resulttmp[4],resulttmp[5],resulttmp[6],resulttmp[7],resulttmp[8],resulttmp[9],resulttmp[10],resulttmp[11],resulttmp[12],resulttmp[13],resulttmp[14],resulttmp[15],resulttmp[16],resulttmp[17],resulttmp[18],resulttmp[19],resulttmp[20],resulttmp[21],resulttmp[22],resulttmp[23],resulttmp[24],resulttmp[25],resulttmp[26],resulttmp[27],resulttmp[28],resulttmp[29],resulttmp[30],resulttmp[31]);
and a1(sign,src1[31],src2[31]);
xor x1(overfl,sign,resulttmp[31]);
assign set = src1[31]+!(src2[31])+couttmp[30];

always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		zero=0;
		result=0;
		cout=0;
		overflow=0;
	end
	else begin
		zero=zro;
		result=resulttmp;
		cout=(ALU_control[1:0]==2'b10)?couttmp[31]:0;
		overflow=(ALU_control[1:0]==2'b10)?overfl:0;
	end
end

endmodule
