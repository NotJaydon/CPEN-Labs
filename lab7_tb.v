module lab7_tb ();

reg err;
reg [3:0] KEY;
reg [9:0] SW;
wire [9:0] LEDR;
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

lab7_top TB(.KEY(KEY), .SW(SW), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1),
		.HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

initial begin
forever begin
KEY[0] = 1'b1;
#5;
KEY[0] = 1'b0;
#5;
end
end

initial begin 
err = 1'b0;
KEY[1] = 1'b0;

if(TB.MEM.mem[0] !== 16'b1101000000001111) begin //checing that the memory contains the right instructions
	err = 1'b1;
	$display("mem didnt load with correct instructions");
end
#10;
KEY[1] = 1'b1;

#60;
if(TB.CPU.DP.REGFILE.R0 !== 16'b0000000000001111) begin //checking that we moved 15 to r0
	err = 1'b1;
	$display("R0 doesnt contain 7"); 
end

#60;
if(TB.CPU.DP.REGFILE.R1 !== 16'b0000000000010010) begin //checking that we moved 18 to r1
	err = 1'b1;
	$display("R1 doesnt contain 2"); 
end

#70;
if(TB.CPU.DP.REGFILE.R2 !== 16'b0000000000110000) begin //checking that the addition to r2 worked
	err = 1'b1;
	$display("R2 doesnt contain 16"); 
end
#100;
if(TB.MEM.mem[49]!== 16'b0000000000010010) begin //the next instr is to store the contents of r1 into the [r2 + 1)]
	err = 1'b1;				 //so we check that mem 49 contains 18
	$display("Error mem[17] should contain 2");
end

#90; 
if(TB.CPU.DP.REGFILE.R1 !== 16'b0000000000010010) begin //the next instr is to load the contents of [r2 + 1] back
	err = 1'b1;					//into R3
	$display("Error, R3 should contain 2");
end


#60;

if(TB.CPU.controller_fsm_1.present_state !== 5'b11111) begin //here we need to test whether the state machine stays
	err = 1'b1;					     //stays in the halt state
	$display("fsm should stay in halt stage");
end

if(err == 1'b0)
	$display("No Errors");

$stop;

end 

endmodule
