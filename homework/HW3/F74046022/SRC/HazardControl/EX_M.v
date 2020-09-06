// EX_M

module EX_M ( clk,
			  rst,
			  // input 
			  // WB
			  EX_MemtoReg,
			  EX_RegWrite,
			  // M
			  EX_MemWrite,
			  // write your code in here
			  // pipe
			  EX_ALU_result,
			  EX_Rt_data,
			  EX_PCplus8,
			  EX_WR_out,
			  // output
			  // WB
			  M_MemtoReg,
			  M_RegWrite,
			  // M
			  M_MemWrite,
			  // write your code in here
			  // pipe
			  M_ALU_result,
			  M_Rt_data,
			  M_PCplus8,
			  M_WR_out,
			  // CUSTOM
			  EX_Link,
			  EX_Half,
			  M_Link,
			  M_Half
			  );
	
	parameter pc_size = 18;	
	parameter data_size = 32;
	
	input clk, rst;		  
			  
	// WB		  
	input EX_MemtoReg;
    input EX_RegWrite;
    // M
    input EX_MemWrite;
	// write your code in here
	// pipe		  
	input [data_size-1:0] EX_ALU_result;
    input [data_size-1:0] EX_Rt_data;
    input [pc_size-1:0] EX_PCplus8;
    input [4:0] EX_WR_out;
	
	// WB
	output reg M_MemtoReg;	
	output reg M_RegWrite;	
	// M	
	output reg M_MemWrite;	
	// write your code in here
	// pipe		  
	output reg [data_size-1:0] M_ALU_result;
	output reg [data_size-1:0] M_Rt_data;
	output reg [pc_size-1:0] M_PCplus8;
	output reg [4:0] M_WR_out;
	
	
	
	// write your code in here
	input EX_Link, EX_Half;
	output reg M_Link, M_Half;
	
	always@(negedge clk or posedge rst) begin
		if(rst) begin
			M_MemtoReg = 0;
			M_RegWrite = 0;
			M_MemWrite = 0;
			M_ALU_result = 0;
			M_Rt_data = 0;
			M_PCplus8 = 0;
			M_WR_out = 0;
			
			M_Link = 0;
			M_Half = 0;
		end
		else begin
			M_MemtoReg = EX_MemtoReg;
			M_RegWrite = EX_RegWrite;
			M_MemWrite = EX_MemWrite;
			M_ALU_result = EX_ALU_result;
			M_Rt_data = EX_Rt_data;
			M_PCplus8 = EX_PCplus8;
			M_WR_out = EX_WR_out;
			
			M_Link = EX_Link;
			M_Half = EX_Half;
		end
	end
	
endmodule
