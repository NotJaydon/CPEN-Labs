module Dec38(in, out);
	input [2:0] in;
	output [7:0] out;

	wire [7:0] out = 1 << in;
endmodule
