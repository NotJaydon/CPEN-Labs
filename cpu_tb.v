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
sim_clk = 1'b1;
forever begin   //we are running the clock cycles in the background of the test suite
#2;		//the clock cycles last 2 ps so it takes 4 ps for a risedge to come along
sim_clk = 1'b0;
#2;
sim_clk = 1'b1;
end
end

initial begin
err = 1'b0;
sim_in = 16'b1101000000000100; //mov r0, #4
sim_s = 1'b1;
sim_reset = 1'b0;
sim_load = 1'b1;
#12; //we delay by 4ps*(number of risedge clks we need)
				//Test #1: mov between registers
sim_in = 16'b1100000000100000; // mov r1, r0
#8;

if(sim_out != 16'b0000000000000100) begin //if statements are used throughout to check
					  //if the changes were made/not made correctly
	err = 1'b1;
	$display("Error: r0 is %b, expected 4", sim_out);
end
				//Test #2: load
sim_in = 16'b1100000001001000; // mov r2, r0, LSL #1
sim_load = 1'b0; //load is set to 0 to make sure that no changes occur when its 0
#8;

if(sim_out == 16'b0000000000001000) begin //if it has updated, there is an error
	err = 1'b1;
	$display("Error: r0 should not have updated to 8");
end

sim_in = 16'b1101001001110011; //mov r2, #115
sim_load = 1'b1; //load is back to 1 to proceed with future tests
#12;
				// Test #3: adding with left shift
sim_in = 16'b1010001001101001;  //add r3, r2, r1, LSL #1
#24;
if(sim_out != 16'b0000000001111011) begin //output should be 123
	err = 1'b1;
	$display("Error: out is %b, expected 123", sim_out);
end
				// Test #4: And with right shift
sim_in = 16'b1011001110010000;  // and r4, r3, r0, LSR #1
#24;
if(sim_out != 16'b0000000000000010) begin //output should be 2
	err = 1'b1;
	$display("Error: out is %b, expected 2", sim_out);
end
				//Test #5: mvn without shift
sim_in = 16'b1011100010100010;  // mvn r5, r2
#24;
if(sim_out != 16'b1111111110001100) begin //output should be -116
	err = 1'b1;
	$display("Error: out is %b, expected -116", sim_out);
end
		// The following tests are using cmp to test the Z N V outputs
sim_in = 16'b1010100000010001; //Test #6: cmp r0(4), r1(4), LSR #1;
#24;
if(sim_N != 1'b0) //4-2 = 2 the N should be 0
	err = 1'b1;

sim_in = 16'b1010100000001001; //Test #7: cmp r0(4), r1(4), LSL #1;
#24;
if(sim_N != 1'b1) //4-8 = -4 the N should be 1
	err = 1'b1;

sim_in = 16'b1010100000000001; //Test #8: cmp r0, r1
#24;
if(sim_Z != 1'b1 || sim_N == 1'b1) //4-4 = 0 the Z should be 1;
	err = 1'b1;
		//Test #9: testing the s/w
sim_s = 1'b0; //setting s to 0
#12; //run through some cycles

if(sim_w != 1'b1) begin //w should be set to 1
	err = 1'b1;
	$display("Error: w should be 1");
end

sim_in = 16'b1101000100000010;
sim_s = 1'b1;
#12;

$display("%b", cpu_tb.TB.DP.REGFILE.R1);
#4;
if(err == 1'b0)
	$display("No Errors :)");
$stop;

end
endmodule






