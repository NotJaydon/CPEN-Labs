module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire [15:0] dout, read_data, write_data;
	wire [8:0] mem_addr;
	wire [1:0] mem_cmd;
	wire enable, write; // TSIread, enablewrite;
	

	reg is_memory_address, is_read_command, is_write_command, TSIread, enablewrite;

	`define MNONE 2'b00
	`define MREAD 2'b01
	`define MWRITE 2'b11
	
	//Not sure what to do with N, V or Z and also not sure about the output being displayed?
	//don't forget to add a write wire/reg, I'm not sure as yet
	//same for write_data
	//same for dout
	cpu CPU(.clk(~KEY[0]), .reset(~KEY[1]), .mem_cmd(mem_cmd), .mem_addr(mem_addr), //instantiation of our CPU module
		.read_data(read_data), .out(write_data), .N(N), .V(V), .Z(Z));

	RAM #(16,8,"data.txt")MEM(.clk(~KEY[0]), .read_address(mem_addr[7:0]), .write_address(mem_addr[7:0]), //instantiation of ram module with the file
		.write(write), .din(write_data), .dout(dout));						//the file name specified in the parameters

	always @* begin //always block that determines whether we have a valid memory address based on the eight bit of mem_addr
		if (mem_addr[8] == 1'b0)
			is_memory_address = 1'b1;
		else
			is_memory_address = 1'b0;
	end

	always @* begin //splits the memory command into 1 bit indicators for future use in tri state buffers and load regs
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

	if(mem_cmd == 2'b01 && mem_addr == 9'h140) //conditions for switches tri state buffer wire
		TSIread = 1'b1;
	else
		TSIread = 1'b0;


	if(mem_cmd == 2'b11 && mem_addr == 9'h100) //conditions for LED load register wire
		enablewrite = 1'b1;
	else
		enablewrite = 1'b0;
	end

	vDFF_w_Load #(8)write_load(.clock(~KEY[0]), .set(enablewrite), .din(write_data[7:0]), .dout(LEDR[7:0]));  //using the vDFF register to hold led values

	assign enable = is_read_command & is_memory_address; //enable will allow read opertaion when read command and memory address are correct
	assign write = is_write_command & is_memory_address; //write will allow write opertaion when write command and memory adress are correct
	assign read_data = enable ? dout : {16{1'bz}}; //tristate buffer with enable allowing the memory block to output value
 
	assign read_data[7:0] = TSIread ? SW[7:0] : {8{1'bz}}; //Tri state buffers that determine the input from
	assign read_data[15:8] = TSIread ? {8{1'b0}} : {8{1'bz}}; //the switches

endmodule
