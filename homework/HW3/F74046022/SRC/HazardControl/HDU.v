// Hazard Detection Unit

module HDU ( // input
			 ID_Rs,
             ID_Rt,
			 EX_WR_out,
			 EX_MemtoReg,
			 EX_JumpOP,
			 // output
			 // write your code in here
			 PC_Write,
			 IF_IDWrite,
			 IF_Flush,
			 ID_Flush
			 );
	
	parameter bit_size = 32;
	
	input [4:0] ID_Rs;
	input [4:0] ID_Rt;
	input [4:0] EX_WR_out;
	input EX_MemtoReg;
	input [1:0] EX_JumpOP;
	
	
	
	// write your code in here
	output PC_Write, IF_IDWrite, IF_Flush, ID_Flush;
	wire Stall, Jumped;
	
	assign Stall = EX_MemtoReg && (EX_WR_out==ID_Rs || EX_WR_out==ID_Rt);
	assign Jumped = (EX_JumpOP>2'b0);
	
	assign PC_Write = Stall;
	assign IF_IDWrite = Stall;
	assign IF_Flush = 0;
	assign ID_Flush = (Stall || Jumped);
	
endmodule