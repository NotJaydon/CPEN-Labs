module instrucreg(clk, in, load, out);
	input [15:0] in;
	input load, clk;
	output [15:0] out;

	reg [15:0] out;
	reg [15:0] mux_out;

	always @* begin 	//checking whether we should update current data with input
		if (load == 1'b0)
			mux_out = out;
		else
			mux_out = in;
	end

	always @(posedge clk) begin 	//outputting the data when clk rises
		out = mux_out;
	end
endmodule
