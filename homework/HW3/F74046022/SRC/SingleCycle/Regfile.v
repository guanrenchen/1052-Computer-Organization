// Regfile

module Regfile ( clk, 
		 rst,
		 Read_addr_1,
		 Read_addr_2,
		 Read_data_1,
         Read_data_2,
		 RegWrite,
		 Write_addr,
		 Write_data);
	
	parameter bit_size = 32;
	parameter reg_num = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;
	
	
	
	// write your code in here
	reg [bit_size-1:0] Reg[reg_num-1:0];
	integer i;
	
	assign Read_data_1 = Reg[Read_addr_1];
	assign Read_data_2 = Reg[Read_addr_2];
	
	always@(posedge clk or posedge rst) begin
		if(rst)
			for(i=0; i<32; i=i+1) Reg[i] = 0;
		else if(RegWrite && Write_addr!=5'b0)
			Reg[Write_addr] = Write_data;
	end

endmodule






