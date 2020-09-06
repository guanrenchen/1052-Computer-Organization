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

	/*****DEFAULT*****/
	parameter data_size = 32;
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

	/*****WIRES*****/
	// Fundamental
	wire ALUSrc, RegDst, RegWrite, Jump, Link, DM_enable, Half, MemToReg, Zero;
	wire [1:0] JumpOP, Type;
	wire [3:0] ALUOp;
	wire [4:0] rs, rt, rd, ra, Read_addr_1, Read_addr_2, Write_addr, shamt;
	wire [5:0] opcode, funct;
	wire [15:0] imm;
	wire [17:0] PC_Normal, PC_Branch, PC_Register, PC_Address, PCin, PCout; 
	wire [31:0] Read_data_1, Read_data_2, Write_data, src1, src2, ALU_result;
	// Derived
	wire [31:0] imm_32, PC8_32, Read_data_2_SignExt, DM_Read_Data_SignExt;
	
	/*****ASSIGNMENTS*****/
	// Fundamental
	assign opcode = Instruction[31:26];
	assign rs = Instruction[25:21];
	assign rt = Instruction[20:16];
	assign rd = Instruction[15:11];
	assign shamt = Instruction[10:6];
	assign funct = Instruction[5:0];
	assign imm = Instruction[15:0];
	assign ra = 5'b11111;
	// Derived
	assign imm_32 = {{16{imm[15]}}, imm};
	assign PC_Normal = PCout + 4;
	assign PC_Branch = PC_Normal + {imm, 2'b0};
	assign PC_Register = Read_data_1[17:0];
	assign PC_Address = {imm, 2'b0};
	assign PC8_32 = {16'b0, (PC_Normal+4)};
	/*
	always@(posedge clk) begin
		$display("Instruction: %h", Instruction);
		$display("opcode : %b", opcode);
		$display("funct : %b", funct);
		$display("rs : %d", rs);
		$display("rt : %d", rt);
		$display("rd : %d", rd);
		$display("shamt : %d", shamt);
		$display("imm : %d", imm);
		
		$display("IM_Address : %d", IM_Address);
		$display("DM_Address : %d", DM_Address);
		$display("DM_enable : %b", DM_enable);
		$display("DM_Write_Data : %h", DM_Write_Data);
		$display("DM_Read_Data : %h", DM_Read_Data);
		
		$display("Read_data1: %h",Read_data_1);
		$display("Read_data2: %h",Read_data_2); 
		$display("ALUOp : %h",ALUOp);
		$display("src1 : %b", src1);
		$display("src2 : %b", src2);
		$display("ALU_result: %b",ALU_result);
		$display("Write_addr: %d",Write_addr);
			
		$display("PCout : %d",PCout);				
		$display("PC8_32 : %d",PC8_32);		
		$display("PC_Normal : %d",PC_Normal);	
		$display("PC_Branch : %d",PC_Branch);	
		$display("PC_Register : %d",PC_Register);
		$display("PC_Address : %d",PC_Address);
		$display("JumpOP: %b",JumpOP);
		$display("PCin: %d",PCin);	
		
		$display("");
	end
	*/
	
	//Controller
	wire [3:0] ALUOp_Controller;
	Controller controller(opcode, funct, ALUOp_Controller, ALUSrc, RegDst, RegWrite, Jump, Link, DM_enable, Half, MemToReg, Type);	
	
	//RegFile
	assign Read_addr_1 = rs;
	assign Read_addr_2 = rt;
	wire [4:0] RtRd;
	assign RtRd = RegDst? rd: rt;
	assign Write_addr = Link? ra: RtRd;
	wire [31:0] Dm, DmAlu;
	assign Read_data_2_SignExt = {{16{Read_data_2[15]}}, Read_data_2[15:0]};
	assign Dm = Half? DM_Read_Data_SignExt: DM_Read_Data;
	assign DmAlu = MemToReg? Dm: ALU_result;
	assign Write_data = Link? PC8_32: DmAlu;
	Regfile regfile(clk, rst, Read_addr_1, Read_addr_2, Read_data_1, Read_data_2, RegWrite, Write_addr, Write_data);
	
	//ALU
	assign ALUOp = (Instruction==0)? 4'b0: ALUOp_Controller;
	assign src1 = Read_data_1;
	assign src2 = ALUSrc? imm_32: Read_data_2;
	ALU alu(ALUOp, src1, src2, shamt, ALU_result, Zero);
	
	//DM
	assign DM_Address = ALU_result[17:2];
	assign DM_Read_Data_SignExt = {{16{DM_Read_Data[15]}}, DM_Read_Data[15:0]};
	assign DM_Write_Data = Half? Read_data_2_SignExt: Read_data_2;
	
	//Jump_Ctrl
	Jump_Ctrl jump_ctrl(Zero, JumpOP, Jump, Type);
	
	//PC
	assign PCin = JumpOP[1]? (JumpOP[0]? PC_Address: PC_Register): (JumpOP[0]? PC_Branch: PC_Normal);
	PC pc(clk, rst, PCin, PCout);
	
	//IM
	assign IM_Address = PCout[17:2];
	
endmodule
