module instrucDec(in, nsel, opcode, op, readnum, writenum, sximm8, sximm5, ALUop);
	input [15:0] in;
	input nsel;
	output [2:0] opcode, readnum, writenum;
	output [1:0] op, ALUop, shift;
	output [15:0] sximm8, sximm5;

	wire [2:0] Rn, Rd, Rm;

always @(*) begin

	opcode = in[15:13];
	op = in[12:11];
	ALUop = in[12:11];
	sximm8 = { {8{in[7]}}, in[7:0]};
	sximm5 = { {11{in[4]}}, in[4:0]};
	shift = in[4:3];
end

assign Rn = in[10:8];
assign Rd = in[7:5];
assign Rm = in[2:0];


	