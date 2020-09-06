// Jump_Ctrl

module Jump_Ctrl(	Zero,
                 	JumpOP,
		  	// write your code in here
			Jump,
			Type
		  );

	input Zero;
	output [1:0] JumpOP;

	// write your code in here
	parameter TR=2'b00, TI=2'b01, TJ=2'b10;
	
	input Jump;
	input [1:0] Type;
	reg [1:0] JumpOP;

	always@(Zero or Jump or Type) begin
		case(Type)
		TR: JumpOP = Jump? 2'b10: 2'b00;
		TI: JumpOP = (Jump&Zero)? 2'b01: 2'b00;
		TJ: JumpOP = Jump? 2'b11: 2'b00;
		endcase
	end

endmodule





