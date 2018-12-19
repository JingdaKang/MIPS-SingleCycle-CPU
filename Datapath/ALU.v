

module ALU(aluout_o,zero_o,src0_i,src1_i,aluop_i);

	input  [31:0] 		src0_i;		
	input  [31:0]		src1_i;		
	input  [1:0]		aluop_i;		
	
	output reg[31:0]		aluout_o;			
	output	zero_o;			

	
	
	
	always@(*)
	begin
		case(aluop_i)
			2'b00:
				begin
				aluout_o = src0_i + src1_i;
				end
			2'b01:
				begin
				aluout_o = src0_i - src1_i;
				end
			2'b10:
				begin
				aluout_o = src0_i | src1_i;
				end
		endcase
	
	end
	assign zero_o = (aluout_o == 32'b0) ? 1'b1 : 1'b0; 

endmodule