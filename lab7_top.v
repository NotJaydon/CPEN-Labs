module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire [15:0] dout, read_data, write_data;
	wire [8:0] mem_addr;
	wire [1:0] mem_cmd;
	wire enable, write;

	reg is_memory_address, is_read_command, is_write_command;

	`define MNONE 2'b00
	`define MREAD 2'b01
	`define MWRITE 2'b11
	
	//Not sure what to do with N, V or Z and also not sure about the output being displayed?
	//don't forget to add a write wire/reg, I'm not sure as yet
	//same for write_data
	//same for dout
	cpu CPU(.clk(~KEY[0]), .reset(~KEY[1]), .mem_cmd(mem_cmd), .mem_addr(mem_addr),
		.read_data(read_data), .out(write_data), .N(N), .V(V), .Z(Z));

	RAM MEM(.clk(~KEY[0]), .read_address(mem_addr[7:0]), .write_address(mem_addr[7:0]),
		.write(write), .din(write_data), .dout(dout));

	always @* begin
		if (mem_addr[8] == 1'b0)
			is_memory_address = 1'b1;
		else
			is_memory_address = 1'b0;
	end

	always @* begin
		if (mem_cmd == `MREAD) begin
			is_read_command = 1'b1;
			is_write_command = 1'b0;
		end
		else if (mem_cmd == `MWRITE) begin
			is_read_command = 1'b0;
			is_write_command = 1'b1;
		end
		else begin
			is_read_command = 1'b0;
			is_write_command = 1'b0;
		end
	end

	assign enable = is_read_command & is_memory_address;
	assign write = is_write_command & is_memory_address;
	assign read_data = enable ? dout : {16{1'bz}};
endmodule
