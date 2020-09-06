// ID_EX

module ID_EX ( clk,  
               rst,
               // input 
			   ID_Flush,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M
			   ID_MemWrite,
			   // write your code in here
			   // EX
			   ID_Reg_imm,
			   // write your code in here	   
			   // pipe
			   ID_PC,
			   ID_ALUOp,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
			   // output
			   // WB
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemWrite,
			   // write your code in here
			   // EX
			   EX_Reg_imm,
			   // write your code in here
			   // pipe
			   EX_PC,
			   EX_ALUOp,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt,
			   // CUSTOM
			   ID_Jump,
			   ID_Link,
			   ID_Half,
			   ID_JumpType,
			   EX_Jump,
			   EX_Link,
			   EX_Half,
			   EX_JumpType
			   );
	
	parameter pc_size = 18;			   
	parameter data_size = 32;
	
	input clk, rst;
	input ID_Flush;
	
	// WB
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite;
	// write your code in here
	// EX
	input ID_Reg_imm;
	// write your code in here
	// pipe
    input [pc_size-1:0] ID_PC;
    input [3:0] ID_ALUOp;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
	
	// WB
	output reg EX_MemtoReg;
	output reg EX_RegWrite;
	// M
	output reg EX_MemWrite;
	// write your code in here
	// EX
	output reg EX_Reg_imm;
	// write your code in here
	// pipe
	output reg[pc_size-1:0] EX_PC;
	output reg[3:0] EX_ALUOp;
	output reg[4:0] EX_shamt;
	output reg[data_size-1:0] EX_Rs_data;
	output reg[data_size-1:0] EX_Rt_data;
	output reg[data_size-1:0] EX_se_imm;
	output reg[4:0] EX_WR_out;
	output reg[4:0] EX_Rs;
	output reg[4:0] EX_Rt;
	
	
	
	// write your code in here
	input ID_Jump, ID_Link, ID_Half;
	input[1:0] ID_JumpType;
	output reg EX_Jump, EX_Link, EX_Half;
	output reg[1:0] EX_JumpType;
	
	always@(negedge clk or posedge rst) begin
		if(rst || ID_Flush) begin
			EX_MemtoReg = 0;
			EX_RegWrite = 0;
			EX_MemWrite = 0;
			EX_Reg_imm = 0;
			EX_PC = 0;
			EX_ALUOp = 0;
			EX_shamt = 0;
			EX_Rs_data = 0;
			EX_Rt_data = 0;
			EX_se_imm = 0;
			EX_WR_out = 0;
			EX_Rs = 0;
			EX_Rt = 0;
			
			EX_Jump = 0;
			EX_Link = 0;
			EX_Half = 0;
			EX_JumpType = 2'b0;
		end
		else begin
			EX_MemtoReg = ID_MemtoReg;
			EX_RegWrite = ID_RegWrite;
			EX_MemWrite = ID_MemWrite;
			EX_Reg_imm = ID_Reg_imm;
			EX_PC = ID_PC;
			EX_ALUOp = ID_ALUOp;
			EX_shamt = ID_shamt;
			EX_Rs_data = ID_Rs_data;
			EX_Rt_data = ID_Rt_data;
			EX_se_imm = ID_se_imm;
			EX_WR_out = ID_WR_out;
			EX_Rs = ID_Rs;
			EX_Rt = ID_Rt;

			EX_Jump = ID_Jump;
			EX_Link = ID_Link;
			EX_Half = ID_Half;	
			EX_JumpType = ID_JumpType;
		end
	end
	
endmodule










