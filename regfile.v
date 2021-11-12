module regfile(data_in, writenum, write, readnum, clk, data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;

	wire [7:0] dec_out;
	wire [7:0] load;
	wire [7:0] register [15:0];
	wire [7:0] dout_selector;
	reg [15:0] data_out;

	Dec38 reg_Dec38_1(.in(writenum), .out(dec_out));

	assign load = (dec_out & {8{write}});

	vDFF_w_Load #(16) R7(.clock(clk), .set(load[7]), .din(data_in), .dout(register[7]));
	vDFF_w_Load #(16) R6(.clock(clk), .set(load[6]), .din(data_in), .dout(register[6]));
	vDFF_w_Load #(16) R5(.clock(clk), .set(load[5]), .din(data_in), .dout(register[5]));
	vDFF_w_Load #(16) R4(.clock(clk), .set(load[4]), .din(data_in), .dout(register[4]));
	vDFF_w_Load #(16) R3(.clock(clk), .set(load[3]), .din(data_in), .dout(register[3]));
	vDFF_w_Load #(16) R2(.clock(clk), .set(load[2]), .din(data_in), .dout(register[2]));
	vDFF_w_Load #(16) R1(.clock(clk), .set(load[1]), .din(data_in), .dout(register[1]));
	vDFF_w_Load #(16) R0(.clock(clk), .set(load[0]), .din(data_in), .dout(register[0]));

	Dec38 reg_Dec38_2(.in(readnum), .out(dout_selector));

	always @* begin
		case (dout_selector)
			8'b10000000: data_out = register[7];
			8'b01000000: data_out = register[6];
			8'b00100000: data_out = register[5];
			8'b00010000: data_out = register[4];
			8'b00001000: data_out = register[3];
			8'b00000100: data_out = register[2];
			8'b00000010: data_out = register[1];
			8'b00000001: data_out = register[0];
			default: data_out = 8'bxxxxxxxx;
		endcase
	end
endmodule
