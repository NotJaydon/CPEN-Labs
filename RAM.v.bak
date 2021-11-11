module vDFF_w_Load(clock, set, din, dout);
	input clock, set;
	input [15:0] din;
	output [15:0] dout;

	reg [15:0] mux_out;
	reg [15:0] dout;

	always @* begin
		if (load == 1'b0)
			mux_out = dout;
		else
			mux_out = din;
	end

	always @(posedge clock) begin
		out = mux_out;
	end
endmodule
