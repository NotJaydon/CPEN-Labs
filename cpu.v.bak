module cpu(clk, reset, s, load, in, out, N, V, Z, w)
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] load;
	output N, V, Z, w;

	wire[15:0] instruc;

instrucreg instrucreg_1 (.in(in), .instruc(regout));

