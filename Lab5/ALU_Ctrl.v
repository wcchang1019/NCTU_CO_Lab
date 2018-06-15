//0516094 0516077
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(*) begin
    case(ALUOp_i)
        3'b100:begin
            case(funct_i)
                6'b100000:begin//32 add
                    ALUCtrl_o <= 4'b0010;
                end
                6'b100010:begin//34 sub
                    ALUCtrl_o <= 4'b0110;
                end
                6'b100100:begin//36 and
                    ALUCtrl_o <= 4'b0000;
                end             
                6'b100101:begin//37 or
                    ALUCtrl_o <= 4'b0001;
                end
                6'b101010:begin//42 slt
                    ALUCtrl_o <= 4'b0111;
                end
                6'b001000:begin//   jr
                    ALUCtrl_o <= 4'b1011;
                end
		6'b011000:begin//24 mul
		    ALUCtrl_o <= 4'b1111;
		end
                default: ALUCtrl_o <= 4'bxxxx;
            endcase
        end

        3'b000:begin //addi
            ALUCtrl_o <= 4'b0010;
        end

        3'b010:begin //slti
            ALUCtrl_o <= 4'b0111;
        end

        3'b001:begin //beq
            ALUCtrl_o <= 4'b0110;
        end
        3'b101:begin //bne
            ALUCtrl_o <= 4'b1000;
        end
        3'b110:begin //bge bgt
            ALUCtrl_o <= 4'b0110;
        end     
        default: ALUCtrl_o <= 4'bxxxx;
    endcase
end

endmodule     





                    
                    