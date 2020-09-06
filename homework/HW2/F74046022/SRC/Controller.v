// Controller

module Controller (	opcode,
			funct,
			// write your code in here
			ALUOp,
			ALUSrc,
			RegDst,
			RegWrite,
			Jump,
			Link,
			DM_enable,
			Half,
			MemToReg,
			Type
	);

	input  [5:0] opcode;
	input  [5:0] funct;

	// write your code in here
	output reg[3:0] ALUOp;
	output reg ALUSrc, RegDst, RegWrite, Jump, Link, DM_enable, Half, MemToReg;
	output reg [1:0] Type;
	parameter NOP=4'h0, ADD=4'h1, SUB=4'h2, AND=4'h3, OR=4'h4, XOR=4'h5, NOR=4'h6, SLT=4'h7, SLL=4'h8, SRL=4'h9, BEQ=4'hA, BNE=4'hB, JR=4'hC, JALR=4'hD, J=4'hE, JAL=4'hF;
	parameter TR=2'b00, TI=2'b01, TJ=2'b10;
	
	always@(opcode or funct) begin
		case(opcode)
		/*****R TYPE*****/
		6'b000000: begin		
			Type=TR; ALUSrc=0; RegDst=1; DM_enable=0; Half=0; MemToReg=0;
			case(funct)
			6'b100000: begin ALUOp=ADD;  RegWrite=1; Jump=0; Link=0; end 
			6'b100010: begin ALUOp=SUB;  RegWrite=1; Jump=0; Link=0; end 
			6'b100100: begin ALUOp=AND;  RegWrite=1; Jump=0; Link=0; end 
			6'b100101: begin ALUOp=OR;   RegWrite=1; Jump=0; Link=0; end 
			6'b100110: begin ALUOp=XOR;  RegWrite=1; Jump=0; Link=0; end 
			6'b100111: begin ALUOp=NOR;  RegWrite=1; Jump=0; Link=0; end 
			6'b101010: begin ALUOp=SLT;  RegWrite=1; Jump=0; Link=0; end 
			6'b000000: begin ALUOp=SLL;  RegWrite=1; Jump=0; Link=0; end 
			6'b000010: begin ALUOp=SRL;  RegWrite=1; Jump=0; Link=0; end 
			6'b001000: begin ALUOp=JR;   RegWrite=0; Jump=1; Link=0; end 
			6'b001001: begin ALUOp=JALR; RegWrite=1; Jump=1; Link=1; end
			endcase
		end
		/*****I TYPE*****/
		6'b001000: begin Type=TI; ALUOp=ADD;  ALUSrc=1; RegDst=0; RegWrite=1; Jump=0; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b001100: begin Type=TI; ALUOp=AND;  ALUSrc=1; RegDst=0; RegWrite=1; Jump=0; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b001010: begin Type=TI; ALUOp=SLT;  ALUSrc=1; RegDst=0; RegWrite=1; Jump=0; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b000100: begin Type=TI; ALUOp=BEQ;  ALUSrc=0; RegDst=0; RegWrite=0; Jump=1; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b000101: begin Type=TI; ALUOp=BNE;  ALUSrc=0; RegDst=0; RegWrite=0; Jump=1; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b100011: begin Type=TI; ALUOp=ADD;  ALUSrc=1; RegDst=0; RegWrite=1; Jump=0; Link=0; DM_enable=0; Half=0; MemToReg=1; end 
		6'b100001: begin Type=TI; ALUOp=ADD;  ALUSrc=1; RegDst=0; RegWrite=1; Jump=0; Link=0; DM_enable=0; Half=1; MemToReg=1; end 
		6'b101011: begin Type=TI; ALUOp=ADD;  ALUSrc=1; RegDst=0; RegWrite=0; Jump=0; Link=0; DM_enable=1; Half=0; MemToReg=0; end 
		6'b101001: begin Type=TI; ALUOp=ADD;  ALUSrc=1; RegDst=0; RegWrite=0; Jump=0; Link=0; DM_enable=1; Half=1; MemToReg=0; end 
		/*****J TYPE*****/
		6'b000010: begin Type=TJ; ALUOp=J;    ALUSrc=0; RegDst=0; RegWrite=0; Jump=1; Link=0; DM_enable=0; Half=0; MemToReg=0; end 
		6'b000011: begin Type=TJ; ALUOp=JAL;  ALUSrc=0; RegDst=0; RegWrite=1; Jump=1; Link=1; DM_enable=0; Half=0; MemToReg=0; end
		endcase
	end
endmodule
	



