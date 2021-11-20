module cpu(clk, reset, s, load, in, out, N, V, Z, w)
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] load;
	output N, V, Z, w;

	wire [3:0] vsel;
	wire[15:0] instruc, sximm8, sximm5;
	wire [2:0] opcode, writenum, readnum, nsel;
	wire [1:0] op, shift, ALUop;
	wire write, loadb, loada, asel, bsel, loadc, loads;

instrucreg instrucreg_1 (.in(in), .out(instruc));

instrucDec instrucDec_1 (.in(instruc), .opcode(opcode), .op(op), .nsel(nsel),
.writenum(writenum), .readnum(readnum), .shift(shift), .sximm8(sximm8),
.sximm5(sximm5), .ALUop(ALUop));



