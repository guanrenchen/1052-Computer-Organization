// Program Counter

module PC (	clk, 
		rst,
		PCWrite,
		PCin, 
		PCout);
	
	parameter pc_size = 18;
	
	input  clk, rst, PCWrite;
	input  [pc_size-1:0] PCin;
	output reg [pc_size-1:0] PCout;	   
	
	
	
	// write your code in here
	always@(posedge clk or posedge rst) begin
		if(rst)	
			PCout = 0;
		else if(PCWrite)
			PCout = PCout;
		else
			PCout = PCin;
	end
    		   
endmodule

