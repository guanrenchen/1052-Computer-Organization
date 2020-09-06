// ALU

module ALU (	ALUOp,
		src1,
		src2,
		shamt,
		ALU_result,
		Zero);
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output [bit_size-1:0] ALU_result;
	output Zero;

	
	// write your code in here
	parameter NOP=4'h0, ADD=4'h1, SUB=4'h2, AND=4'h3, OR=4'h4, XOR=4'h5, NOR=4'h6, SLT=4'h7, SLL=4'h8, SRL=4'h9, BEQ=4'hA, BNE=4'hB, JR=4'hC, JALR=4'hD, J=4'hE, JAL=4'hF;
	reg [bit_size-1:0] ALU_result;
	reg Zero;

	always@(ALUOp or src1 or src2 or shamt) begin
		case(ALUOp) 
		NOP : begin ALU_result = 0;				Zero = 0; end
		ADD : begin ALU_result = src1 + src2;	Zero = 0; end
		SUB : begin ALU_result = src1 - src2;	Zero = 0; end
		AND : begin ALU_result = src1 & src2; 	Zero = 0; end
		OR  : begin ALU_result = src1 | src2;	Zero = 0; end
		XOR : begin ALU_result = src1 ^ src2;	Zero = 0; end
		NOR : begin ALU_result = ~(src1|src2);	Zero = 0; end
		SLT : begin ALU_result = (src1 < src2);	Zero = 0; end
		SLL : begin ALU_result = src2 << shamt;	Zero = 0; end
		SRL : begin ALU_result = src2 >> shamt;	Zero = 0; end
		BEQ : begin ALU_result = 0; 			Zero = (src1==src2); end
		BNE : begin ALU_result = 0;				Zero = (src1!=src2); end
		JR  : begin ALU_result = 0;				Zero = 0; end
		JALR: begin ALU_result = 0;				Zero = 0; end
		J   : begin ALU_result = 0;				Zero = 0; end				
		JAL : begin ALU_result = 0;				Zero = 0; end			
		endcase
	end

endmodule





