module RF(clk, we, ra0_i,ra1_i,wa_i,wd_i, rd0_o,rd1_o);
	input clk;
	input we;
	input [4:0] ra0_i,ra1_i,wa_i;
	input [31:0] wd_i;
	
	output [31:0] rd0_o,rd1_o;
	
	integer i;
	reg [31:0] regs[31:0];
	
	initial
	     begin
	       for(i=0;i<=31;i=i+1)
	         begin
	           regs[i]=0;
	         end
	     end
	     
	assign rd0_o = (ra0_i==0)?0:regs[ra0_i];
	assign rd1_o = (ra1_i==0)?0:regs[ra1_i];
	
	
	always@(negedge clk)
	begin
		if(we)
			regs[wa_i] <= (wa_i!=5'd0)?wd_i:32'd0;
	end

endmodule