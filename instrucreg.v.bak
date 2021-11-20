module instrucreg(clk, in, load, out);
	input [15:0] in;
	input load, clk;
	output [15:0] out;

	reg [15:0] out;
	reg [15:0] mux_out;

	always @* begin
		if (load == 1'b0)
			mux_out = out;
		else
			mux_out = in;
	end

	always @(posedge clk) begin
		out = mux_out;
	end
endmodule
