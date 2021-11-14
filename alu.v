module ALU(Ain, Bin, ALUop, out, Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output [15:0] out;
	output Z;

	reg [15:0] out;
	reg Z;
	
	always @* begin		//whenever the ALU operation input changes, the output of the ALU should be updated immediately according the selected operation
		case(ALUop)
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = Ain & Bin;
			2'b11: out = ~(Bin);
			default: out = ({16{1'bx}});
		endcase

		if (out == {16{1'b0}})	//if the 16 bit output of the ALU is 0, then the Z output of the ALU should be 1, otherwise 0
			Z = 1'b1;
		else
			Z = 1'b0;
	end
endmodule
