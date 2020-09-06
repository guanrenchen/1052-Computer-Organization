module F_adder(input1,input2,cin,sum,cout);

	input input1,input2,cin;
	output sum,cout;
	
	wire c1, c2, s1, s2;
	
	adder a1(input1, input2, c1, s1);
	adder a2(s1, cin, c2, s2);

	assign cout = c1 | c2;	
	assign sum = s2;

endmodule

