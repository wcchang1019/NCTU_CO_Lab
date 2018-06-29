`timescale 1ns/1ps
//0516094 0516077
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;

wire          src1_temp;
wire          src2_temp;

always@( * )
begin
	if (A_invert==1'b0 & B_invert==1'b0  &  operation==2'b00)
		result=src1 & src2;
	if (A_invert==1'b0  &  B_invert==1'b0  &  operation==2'b01)
		result=src1 | src2;
	if (A_invert==1'b0  &  B_invert==1'b0  &  operation==2'b10)
		result=src1 + src2 + cin;
	if (A_invert==1'b0  &  B_invert==1'b1  &  operation==2'b10)
		result=src1 + !(src2) + cin;
	if (A_invert==1'b1  &  B_invert==1'b1  &  operation==2'b00)
		result=~(src1 | src2);
	if (A_invert==1'b0  &  B_invert==1'b1  &  operation==2'b11)
		result=less;
end
assign cout=(A_invert==1'b0 & B_invert==1'b0 )?((src1 & src2) | (src2 & cin) | (src1 & cin)):((src1 & !(src2)) | (!(src2) & cin) | (src1 & cin));
endmodule
