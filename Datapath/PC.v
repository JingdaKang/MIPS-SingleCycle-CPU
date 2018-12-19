
module PC(clk,rst_n,pc_i,pc_o,PCWr);

	input   clk;
	input   rst_n;
	
	input   PCWr;
	input  [31:0] pc_i;

	
	output reg[31:0] pc_o;

  always@(negedge rst_n)
	 begin
		pc_o <= 32'h0000_3000;
	 end
	
	always@(posedge clk)
	begin
		if(PCWr)
		  begin
		  pc_o <= pc_i;
	    end
	end
endmodule
	
	