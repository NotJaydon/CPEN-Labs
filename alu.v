module ALU(Ain, Bin, ALUop, out, Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output [15:0] out;
	output [2:0] Z;

	reg [15:0] out;
	reg [2:0] Z;
	
	always @* begin		//whenever the ALU operation input changes, the output of the ALU should be updated immediately according the selected operation
		case(ALUop)
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = Ain & Bin;
			2'b11: out = ~(Bin);
			default: out = ({16{1'bx}});
		endcase

		if (out == {16{1'b0}})	//if the 16 bit output of the ALU is 0, then the Z output of the ALU should be 1, otherwise 0
			Z[0] = 1'b1;
		else
			Z[0] = 1'b0;

		if(out[15] == 1'b1)	//we are using signed numbers so if the MSB is a one, then the number is a negative number
			Z[2] = 1'b1;
		else 
			Z[2] = 1'b0;

		if ((Ain[14] & Bin[14]) !== (Ain[15] & Bin[15]))	//if carry in is not equal to carry out for the most significant bit, then there is overflow
			Z[1] = 1'b1;
		else
			Z[1] = 1'b0;
	end
endmodule
