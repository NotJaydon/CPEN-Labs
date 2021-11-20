module instrucDec(in, opcode, op, nsel, writenum, readnum, shift, sximm8, sximm5, ALUop);
	input [15:0] in;
	output [2:0] opcode;
	input [2:0] nsel;
	output [1:0] op, shift, ALUop;
	output [2:0] writenum, readnum;
	output [15:0] sximm8, sximm5;

	reg [4:0] imm5;
	reg [7:0] imm8;
	reg [1:0] ALUop, shift, op;
	reg [2:0] writenum, readnum, opcode, Rn, Rd, Rm;
	reg [15:0] sximm5, sximm8;

	always @* begin
		opcode = in[15:13];
		op = in[12:11];
		Rm = in[2:0];
		Rd = in[7:5];
		Rn = in[10:8];
		shift = in[4:3];
		imm8 = in[7:0];
		imm5 = in[4:0];
		ALUop = in[12:11];
	end

	always @* begin
		case(nsel)
			3'b100: begin writenum = Rn; readnum = Rn; end 
			3'b010: begin writenum = Rd; readnum = Rd; end
			3'b001: begin writenum = Rm; readnum = Rm; end
			default: begin writenum = 3'bxxx; readnum = 3'bxxx; end
		endcase
	end

	always @* begin
		if(imm8[7] == 1'b1) begin
			sximm8 = {8'b11111111, imm8};	//Might work with just 8'b1 but not sure, don't care to find out
		end
		else begin
			sximm8 = {8'b00000000, imm8};
		end
	end

	always @* begin
		if(imm5[4] == 1'b1) begin
			sximm5 = {11'b11111111111, imm5};
		end
		else begin
			sximm5 = {11'b00000000000, imm5};
		end
	end
endmodule
	