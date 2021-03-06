// Program Counter

module PC (	clk, 
		rst,
		PCin, 
		PCout);
	
	parameter bit_size = 18;
	
	input  clk, rst;
	input  [bit_size-1:0] PCin;
	output [bit_size-1:0] PCout;	   
	
	// write your code in here
	reg [bit_size-1:0] PCout;

	initial begin
		PCout = 0;
	end

	always@(posedge clk or posedge rst) begin
		if(rst)	begin
			PCout = 0;
		end
		else begin
			PCout = PCin;
		end
	end
    		   
endmodule

