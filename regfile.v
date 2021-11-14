module regfile(data_in, writenum, write, readnum, clk, data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;

	wire [7:0] dec_out;
	wire [7:0] load;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [7:0] dout_selector;
	reg [15:0] data_out;

	Dec38 reg_Dec38_1(.in(writenum), .out(dec_out));	//3 to 8 decoder needed to converted binary writenum to one hot so that we can select the register to write

	assign load = (dec_out & {8{write}});	//load is the bus of AND gate outputs

	vDFF_w_Load #(16) Reg7(.clock(clk), .set(load[7]), .din(data_in), .dout(R7));	//Implementing register 7
	vDFF_w_Load #(16) Reg6(.clock(clk), .set(load[6]), .din(data_in), .dout(R6));	//Implementing register 6
	vDFF_w_Load #(16) Reg5(.clock(clk), .set(load[5]), .din(data_in), .dout(R5));	//Implementing register 5
	vDFF_w_Load #(16) Reg4(.clock(clk), .set(load[4]), .din(data_in), .dout(R4));	//Implementing register 4
	vDFF_w_Load #(16) Reg3(.clock(clk), .set(load[3]), .din(data_in), .dout(R3));	//Implementing register 3
	vDFF_w_Load #(16) Reg2(.clock(clk), .set(load[2]), .din(data_in), .dout(R2));	//Implementing register 2
	vDFF_w_Load #(16) Reg1(.clock(clk), .set(load[1]), .din(data_in), .dout(R1));	//Implementing register 1
	vDFF_w_Load #(16) Reg0(.clock(clk), .set(load[0]), .din(data_in), .dout(R0));	//Implementing register 0

	Dec38 reg_Dec38_2(.in(readnum), .out(dout_selector));	//3 to 8 decoder needed to converted binary readnum to one hot so that we can select the register to read

	always @* begin		//whenever the register read selector changes, the data output should be updated immediately with the data from the selected register
		case (dout_selector)
			8'b10000000: data_out = R7;
			8'b01000000: data_out = R6;
			8'b00100000: data_out = R5;
			8'b00010000: data_out = R4;
			8'b00001000: data_out = R3;
			8'b00000100: data_out = R2;
			8'b00000010: data_out = R1;
			8'b00000001: data_out = R0;
			default: data_out = 8'bxxxxxxxx;
		endcase
	end
endmodule
