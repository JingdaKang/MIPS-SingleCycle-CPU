module IM(addr_i,dout_o);
 
	input [31:0] addr_i;
	
	output [31:0]  dout_o;
	
	integer i;
	reg [31:0] IMem[1023:0];
	
	initial
	begin
	  for(i=0;i<=1023;i=i+1)
	  begin
	    IMem[i]=32'b0;
	  end
	 end
	
	assign dout_o = IMem[(addr_i>>2)-32'h0000_0c00];
endmodule