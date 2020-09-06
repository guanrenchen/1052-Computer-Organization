// top

module top (	clk,
		rst,
		// Instruction Memory
		IM_Address,
		Instruction,
		// Data Memory
		DM_Address,
		DM_enable,
		DM_Write_Data,
		DM_Read_Data);

/*********DEFAULT*********/
	parameter data_size = 32;
	parameter pc_size = 18;
	parameter mem_size = 16;
	input  clk, rst;
	// Instruction Memory
	output [mem_size-1:0] IM_Address;	
	input  [data_size-1:0] Instruction;
	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;				
	output [data_size-1:0] DM_Write_Data;	
	input  [data_size-1:0] DM_Read_Data;
/*********DEFAULT*********/
	
/**********WIRES**********/
//SINGLE CYCLE
	//PC
	wire [pc_size-1:0] PC_Normal, PC_Branch, PC_Register, PC_Address; 
	wire [1:0] JumpOP;
	wire [pc_size-1:0] PCin, PCout; 
	//EXTRA
	wire [4:0] Rs, Rt, Rd, Ra, shamt;
	wire [15:0] imm;
	//Controller
	wire ALUSrc, RegDst, RegWrite, Jump, Link, MemWrite, Half, MemtoReg, Zero;
	wire [1:0] JumpType;
	wire [3:0] ALUOp_Controller;
	wire [5:0] opcode, funct;
	//RegFile
	wire [4:0] Read_addr_1, Read_addr_2, Write_addr;
	wire [data_size-1:0] Read_data_1, Read_data_2, Write_data;
	//ALU
	wire [3:0] ALUOp;
	wire [data_size-1:0] src1, src2, ALU_result;
//PIPELINE STAGE
	//IF
	wire [pc_size-1:0] IF_PC;
	wire [data_size-1:0] IF_ir;
	//ID
	wire ID_MemtoReg, ID_RegWrite, ID_MemWrite, ID_Reg_imm;
	wire [3:0] ID_ALUOp;
	wire [4:0] ID_shamt, ID_WR_out, ID_Rs, ID_Rt;
	wire [pc_size-1:0] ID_PC;
	wire [data_size-1:0] ID_ir, ID_Rs_data, ID_Rt_data, ID_se_imm;
	wire ID_Jump, ID_Link, ID_Half;
	wire [1:0] ID_JumpType;
	//EX
	wire EX_MemtoReg, EX_RegWrite, EX_MemWrite, EX_Reg_imm;
	wire [3:0] EX_ALUOp;
	wire [4:0] EX_shamt, EX_WR_out, EX_Rs, EX_Rt;
	wire [pc_size-1:0] EX_PC, EX_PCplus8;
	wire [data_size-1:0] EX_Rs_data, EX_Rt_data0, EX_Rt_data1, EX_se_imm, EX_ALU_result;
	wire EX_Jump, EX_Link, EX_Half;
	wire [1:0] EX_JumpType;
	//M
	wire M_MemtoReg, M_RegWrite, M_MemWrite;
	wire [4:0] M_WR_out;
	wire [pc_size-1:0] M_PCplus8;
	wire [data_size-1:0] M_DM_Read_Data, M_WD_out, M_ALU_result, M_Rt_data;
	wire M_Link, M_Half;
	//WB
	wire WB_MemtoReg, WB_RegWrite;
	wire [4:0] WB_WR_out;
	wire [data_size-1:0] WB_DM_Read_Data, WB_WD_out;
//HDU & FU
	//HDU
	wire PC_Write, IF_IDWrite, IF_Flush, ID_Flush; 
	//FU
	wire Fw_Rs, Fw_Rt, Fw_Rs_M, Fw_Rt_M;
/**********WIRES**********/

/********************IF********************/

	//PC
	assign PC_Normal = PCout + 18'd4;
	PC pc(clk, rst, PC_Write, PCin, PCout);
	//PC_in assigned in EX stage
	
	//IM
	assign IM_Address = PCout[17:2];
	
/********************IF********************/
	
	//IF_ID
	assign IF_PC = PC_Normal;
	assign IF_ir = Instruction;
	IF_ID if_id(clk, rst, IF_IDWrite, IF_Flush,
		IF_PC, IF_ir,
		ID_PC, ID_ir
	);
	
/********************ID********************/
	
	//EXTRA
	assign Rs = ID_ir[25:21];
	assign Rt = ID_ir[20:16];
	assign Rd = ID_ir[15:11];
	assign Ra = 5'd31;
	assign imm = ID_ir[15:0];
	assign shamt = ID_ir[10:6];
	
	//Controller
	assign opcode = ID_ir[31:26];
	assign funct = ID_ir[5:0];
	Controller controller(opcode, funct, ALUOp_Controller, ALUSrc, RegDst, RegWrite, Jump, Link, MemWrite, Half, MemtoReg, JumpType);	
	assign ALUOp = (ID_ir==32'b0)? 4'h0: ALUOp_Controller;
	
	//RegFile
	assign Read_addr_1 = Rs;
	assign Read_addr_2 = Rt;
	assign Write_addr = WB_WR_out;
	assign Write_data = WB_MemtoReg? WB_DM_Read_Data: WB_WD_out;
	Regfile regfile(clk, rst, Read_addr_1, Read_addr_2, Read_data_1, Read_data_2, WB_RegWrite, Write_addr, Write_data);

/********************ID********************/

	//ID_EX
	assign ID_MemtoReg = MemtoReg;
	assign ID_RegWrite = RegWrite;
	assign ID_MemWrite = MemWrite;
	assign ID_Reg_imm = ALUSrc;
	assign ID_ALUOp = ALUOp;
	assign ID_shamt = shamt;
	assign ID_Rs_data = Read_data_1;
	assign ID_Rt_data = Read_data_2;
	assign ID_se_imm = {{16{imm[15]}}, imm};
	assign ID_WR_out = Link? Ra: (RegDst? Rd: Rt);
	assign ID_Rs = Rs;
	assign ID_Rt = Rt;
	// CUSTOM
	assign ID_Jump = Jump;
	assign ID_Link = Link;
	assign ID_Half = Half;
	assign ID_JumpType = JumpType;
	ID_EX id_ex(clk, rst, ID_Flush,
		ID_MemtoReg, ID_RegWrite, ID_MemWrite, ID_Reg_imm, ID_PC, ID_ALUOp, ID_shamt, ID_Rs_data, ID_Rt_data, ID_se_imm, ID_WR_out, ID_Rs, ID_Rt, 
		EX_MemtoReg, EX_RegWrite, EX_MemWrite, EX_Reg_imm, EX_PC, EX_ALUOp, EX_shamt, EX_Rs_data, EX_Rt_data0,EX_se_imm, EX_WR_out, EX_Rs, EX_Rt,
		ID_Jump, ID_Link, ID_Half, ID_JumpType,
		EX_Jump, EX_Link, EX_Half, EX_JumpType
	);
	
/********************EX********************/

	//ALU
	assign src1 = Fw_Rs? (Fw_Rs_M? M_WD_out: Write_data): EX_Rs_data;
	assign src2 = EX_Reg_imm? EX_se_imm: EX_Rt_data1;
	ALU alu(EX_ALUOp, src1, src2, EX_shamt, ALU_result, Zero);
	
	//Jump_Ctrl
	Jump_Ctrl jump_ctrl(Zero, JumpOP, EX_Jump, EX_JumpType);
	assign PC_Branch = EX_PC + PC_Address;
	assign PC_Register = src1[17:0];
	assign PC_Address = {EX_se_imm[15:0], 2'b0};
	assign PCin = JumpOP[1]? (JumpOP[0]? PC_Address: PC_Register): (JumpOP[0]? PC_Branch: PC_Normal);

/********************EX********************/

	//EX_M
	assign EX_ALU_result = ALU_result;
	assign EX_Rt_data1 = Fw_Rt? (Fw_Rt_M? M_WD_out: Write_data): EX_Rt_data0;
	assign EX_PCplus8 = EX_PC + 18'd4;
	EX_M ex_m(clk, rst,
		EX_MemtoReg, EX_RegWrite, EX_MemWrite, EX_ALU_result, EX_Rt_data1, EX_PCplus8, EX_WR_out,
		 M_MemtoReg,  M_RegWrite,  M_MemWrite,  M_ALU_result,  M_Rt_data,   M_PCplus8,  M_WR_out,
		EX_Link, EX_Half,
		 M_Link,  M_Half
	);
	
/********************M********************/
	
	//DM
	assign DM_enable = M_MemWrite;
	assign DM_Address = M_ALU_result[17:2];
	assign DM_Write_Data = M_Half? {{16{M_Rt_data[15]}}, M_Rt_data[15:0]}: M_Rt_data;

/********************M********************/

	//M_WB
	assign M_DM_Read_Data = M_Half? {{16{DM_Read_Data[15]}}, DM_Read_Data[15:0]}: DM_Read_Data;
	assign M_WD_out = M_Link? M_PCplus8: M_ALU_result;
	M_WB m_wb(clk, rst,
		 M_MemtoReg,  M_RegWrite,  M_DM_Read_Data,  M_WD_out,  M_WR_out,
		WB_MemtoReg, WB_RegWrite, WB_DM_Read_Data, WB_WD_out, WB_WR_out
	);
	
/********************WB********************/

	//Mux handled in IF section

/********************WB********************/

	//HDU
	HDU hdu(Rs, Rt, EX_WR_out, EX_MemtoReg, /*EX_*/JumpOP, PC_Write, IF_IDWrite, IF_Flush, ID_Flush);
	
	//FU
	FU fu(EX_Rs, EX_Rt, M_RegWrite, M_WR_out, WB_RegWrite, WB_WR_out, 
		  Fw_Rs, Fw_Rt, Fw_Rs_M, Fw_Rt_M);

	
endmodule
