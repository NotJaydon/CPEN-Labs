module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc,
		loads, writenum, write, datapath_in, Z_out, datapath_out);
	input [15:0] datapath_in;
	input clk, write, vsel, loada, loadb, asel, bsel, loadc, loads;
	input [2:0] readnum, writenum;
	input [1:0] ALUop, shift;
	output [15:0] datapath_out;
	output Z_out;

	wire [15:0] data_out, A_out, B_out, sout, out;
	reg [15:0] data_in, Ain, Bin;
	wire Z;

	always @* begin
		case (vsel)
			1'b1: data_in = datapath_in;
			1'b0: data_in = datapath_out;
			default: data_in = {16{1'bx}};
		endcase
	end

	regfile REGFILE (.data_in(data_in), .writenum(writenum), .write(write),
			 .readnum(readnum), .clk(clk), .data_out(data_out));


	vDFF_w_Load #(16) A(.clock(clk), .set(loada), .din(data_out), .dout(A_out));
	vDFF_w_Load #(16) B(.clock(clk), .set(loadb), .din(data_out), .dout(B_out));
	shifter U1(.in(B_out), .shift(shift), .sout(sout));

	always @* begin
		case(asel)
			1'b1: Ain = {16{1'b0}};
			1'b0: Ain = A_out;
			default: Ain = {16{1'bx}};
		endcase
	end

	always @* begin
		case(bsel)
			1'b1: Bin = {11'b0, datapath_in[4:0]};
			1'b0: Bin = sout;
			default: Bin = {16{1'bx}};
		endcase
	end

	ALU U2(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z));
	vDFF_w_Load #(16) C(.clock(clk), .set(loadc), .din(out), .dout(datapath_out));
	vDFF_w_Load #(1) status (.clock(clk), .set(loads), .din(Z), .dout(Z_out));
endmodule
	