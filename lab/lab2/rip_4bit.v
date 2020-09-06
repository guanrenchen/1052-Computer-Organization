module rip_4bit(input1,input2,cin,sum,cout);

input [3:0]input1;
input [3:0]input2;
input cin;
output [3:0]sum;
output cout;
wire [2:0] c;

//F_adder(input1, input2, cin, sum, cout);
F_adder f1(input1[0], input2[0], cin, sum[0], c[0]);
F_adder f2(input1[1], input2[1], c[0], sum[1], c[1]);
F_adder f3(input1[2], input2[2], c[1], sum[2], c[2]);
F_adder f4(input1[3], input2[3], c[2], sum[3], cout);

endmodule

