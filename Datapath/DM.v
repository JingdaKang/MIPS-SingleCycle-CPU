
module DM(clk,DMWr,addr_i,din_i,dout_o);
	input 		 clk;
	input 		 DMWr;
	input [31:0] addr_i;
	input [31:0] din_i;

	output[31:0] dout_o;
	integer i;
	reg [31:0]  DMem[1023:0];
	
	initial
	begin
	  for(i=0;i<=1023;i=i+1)
	   begin
	      DMem[i]<=32'b0;
	   end
	end
	
	assign dout_o = DMem[addr_i>>2];
	always@(negedge clk)
	
	begin
		if(DMWr)
		  begin
			DMem[addr_i>>2] <= din_i;
		
			end
	end

endmodule