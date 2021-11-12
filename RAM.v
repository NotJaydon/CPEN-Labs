module vDFF_w_Load(clock, set, din, dout);
	parameter k = 16;
	input clock, set;
	input [k-1:0] din;
	output [k-1:0] dout;

	reg [k-1:0] mux_out;
	reg [k-1:0] dout;

	always @* begin
		if (set == 1'b0)
			mux_out = dout;
		else
			mux_out = din;
	end

	always @(posedge clock) begin
		dout = mux_out;
	end
endmodule
