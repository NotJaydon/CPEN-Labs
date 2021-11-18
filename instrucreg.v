module instrucreg(in, load, regout)
	input [15:0] in;
	input load;
	output [15:0] regout;

	reg [15:0] regval;
	reg [15:0] regout;

always @(*) begin
     case(load)
	1'b1: regval = in;
	1'b0: regval = regout;
	default: regval = {16{1'b0}};
endcase
end

always @(posedge clk) begin
	regout = regval;
end
endmodule
