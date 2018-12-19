`include "D:/resource/instruction_def.v"
`include "D:/resource/Ctrl.v"
`include "D:/resource/mux.v"
`include "D:/resource/flopr.v"
`include "D:/resource/cpu 7 verilog cai/RF.v"
`include "D:/resource/cpu 7 verilog cai/ALU.v"
`include "D:/resource/EXT.v"
`include "D:/resource/cpu 7 verilog cai/IM.v"
`include "D:/resource/cpu 7 verilog cai/DM.v"
`include "D:/resource/cpu 7 verilog cai/PC.v"
module mips(clk, rst_n);
  input clk;
  input rst_n;
  
  //PC
  wire [31:0] pc_i;
  wire [31:0] pc_o;
  wire PCWr;
  wire [1:0] NPCOp;
  PC mips_PC(.clk(clk), .rst_n(rst_n), .pc_i(pc_i), .pc_o(pc_o), .PCWr(PCWr));
  
  //pc_plus4
	wire [31:0] pc_plus4;
	ALU mips_pc_plus4(.aluout_o(pc_plus4), .zero_o(), .src0_i(pc_o), .src1_i(32'd4), .aluop_i(2'b00));
  
  //IM
  
  wire [31:0] instruction;
  IM mips_IM(.addr_i(pc_o), .dout_o(instruction));
  
  
  
  //Ctrl
  wire Zero;
  wire BSel;
  wire RFWr;
  wire DMWr;
  wire IRWr;
  wire [1:0] WDSel;
  wire [1:0] EXTOp;
  wire [1:0] ALUOp;
  wire [1:0] GPRSel;
  Ctrl mips_Ctrl(.OP(instruction[31:26]), .Funct(instruction[5:0]), .Zero(Zero), .BSel(BSel), .WDSel(WDSel), .RFWr(RFWr), .DMWr(DMWr), .NPCOp(NPCOp), .EXTOp(EXTOp), .ALUOp(ALUOp), .PCWr(PCWr), .IRWr(IRWr), .GPRSel(GPRSel));
  
  //GPRSel_mux
  wire [4:0] Write_register;
  mux #(2,5) mips_GPRSel_mux(.s(GPRSel),.y(Write_register),.d0(instruction[15:11]),.d1(instruction[20:16]),.d2(5'h1F),.d3(5'b0));
  
  
  //RF
  wire [31:0] Write_data;
  wire [31:0] Read_data1;
  wire [31:0] Read_data2;
  RF mips_RF(.clk(clk), .we(RFWr), .ra0_i(instruction[25:21]), .ra1_i(instruction[20:16]), .wa_i(Write_register), .wd_i(Write_data), .rd0_o(Read_data1), .rd1_o(Read_data2));
  
  //EXT
  wire [31:0] extended;
  EXT mips_EXT(.EXTOp(EXTOp), .Imm16(instruction[15:0]), .Imm32(extended));
  
  //BSel_mux
  wire [31:0] src1_i;
  mux #(1,32) mips_BSel_mux(.s(BSel), .y(src1_i), .d0(Read_data2), .d1(extended), .d2(32'b0), .d3(32'b0));
  
  //ALU
  wire [31:0] result;
  ALU mips_ALU(.aluout_o(result), .zero_o(Zero), .src0_i(Read_data1), .src1_i(src1_i), .aluop_i(ALUOp));
  
  //DM
  wire [31:0] Read_data;
  DM mips_DM(.clk(clk), .DMWr(DMWr), .addr_i(result), .din_i(Read_data2), .dout_o(Read_data));
  
  //WDSel_mux
  mux #(2,32) mips_WDSel_mux(.s(WDSel), .y(Write_data), .d0(result), .d1(Read_data), .d2(pc_i), .d3(32'b0));
  
  
	
	//pc_branch
	wire [31:0] pc_branch;
	ALU mips_pc_branch(.aluout_o(pc_branch), .zero_o(), .src0_i(pc_plus4), .src1_i(extended<<2), .aluop_i(2'b00));
	
	//pc_jump
	wire [31:0] pc_jump;
	assign pc_jump = {pc_o[31:28],instruction[25:0],2'b00};
  
  //PC_mux
  wire [1:0] mips_NPCOp;
  assign mips_NPCOp = (NPCOp==2'b01) ? (NPCOp & Zero): NPCOp ;
  
  mux #(2,32) mips_PC_mux(.s(mips_NPCOp), .y(pc_i), .d0(pc_plus4), .d1(pc_branch), .d2(pc_jump), .d3(32'b0));
  

endmodule  

