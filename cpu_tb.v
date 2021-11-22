module cpu_tb();

wire [15:0] sim_out;
wire sim_N, sim_V, sim_Z, sim_w;
reg sim_clk, sim_reset, sim_s, sim_load;
reg [15:0] sim_in;
reg err;

cpu TB(.clk(sim_clk), .reset(sim_reset), .s(sim_s), .load(sim_load),
	.in(sim_in), .out(sim_out), .N(sim_N), .V(sim_V), .Z(sim_Z),
	.w(sim_w));

initial begin
sim_clk = 1'b0;
forever begin
#5;
sim_clk = 1'b1;
#5;
sim_clk = 1'b0;
end
end

initial begin
err = 1'b0;
sim_in = 16'b1101000000000100; //mov r0, #1
sim_s = 1'b1;
sim_reset = 1'b0;
sim_load = 1'b1;
#10; //risedge clk
//sim_load = 1'b1;
#10;
#10;

sim_in = 16'b1100000000100000;
#50;

if(sim_out != 16'b0000000000000100) begin
	err = 1'b1;
	$display("Error: r0 is %b, expected 4", sim_out);
end

sim_in = 16'b1101001001110011;
#30;

sim_in = 16'b1010001001101001;
#60;
if(sim_out != 16'b0000000001111011) begin
	err = 1'b1;
	$display("Error: out is %b, expected 123", sim_out);
end

sim_in = 16'b1011001110010000;
#60;
if(sim_out != 16'b0000000000000010) begin
	err = 1'b1;
	$display("Error: out is %b, expected 2", sim_out);
end

sim_in = 16'b1011100010100010;
#60;
if(sim_out != 16'b1111111110001100) begin
	err = 1'b1;
	$display("Error: out is %b, expected 140", sim_out);
end

sim_in = 16'b1010100000010001;
#60;
if(sim_N != 1'b0)
	err = 1'b1;

sim_in = 16'b1010100000001001;
#60;
if(sim_N != 1'b1)
	err = 1'b1;

sim_in = 16'b1010100000000001;
#60;
if(sim_Z != 1'b1)
	err = 1'b1;


if(err == 1'b0)
	$display("No Errors :)");
$stop;

end
endmodule






