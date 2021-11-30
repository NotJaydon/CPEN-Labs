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

if(TB.MEM.mem[0] !== 16'b1101000000001111) begin //checking that the memory contains the right instructions
	err = 1'b1;
	$display("mem didnt load with correct instructions");
end
#10;
KEY[1] = 1'b1;

#60;	//MOV instruction takes 6 clock cycles starting from reset to get back to IF1
if(TB.CPU.DP.REGFILE.R0 !== 16'b0000000000001111) begin //checking that we moved 15 to r0
	err = 1'b1;
	$display("R0 doesnt contain 15"); 
end

#50;	//MOV instruction takes 5 clock cycles starting from IF1 to get back to IF1
if(TB.CPU.DP.REGFILE.R1 !== 16'b0000000000010010) begin //checking that we moved 18 to r1
	err = 1'b1;
	$display("R1 doesnt contain 18"); 
end

#80;	//ALU instructions other than CMP take 7 clock cycles starting from IF1 to get back to IF1
if(TB.CPU.DP.REGFILE.R2 !== 16'b0000000000110000) begin //checking that the addition to r2 worked
	err = 1'b1;
	$display("R2 doesnt contain 48"); 
end
#100;	//STR instruction takes 10 clock cycles  starting from IF1 to get back to IF1
if(TB.MEM.mem[49]!== 16'b0000000000010010) begin 	//the next instr is to store the contents of r1 into the [r2 + 1)]
	err = 1'b1;				 	//so we check that mem 49 contains 18 since r2 had 48
	$display("Error mem[49] should contain 18");
end

#90; 	//LDR instruction takes 9 clock cycles starting from IF1 to get back to IF1
if(TB.CPU.DP.REGFILE.R3 !== 16'b0000000000010010) begin //the next instr is to load the contents of [r2 + 1] back
	err = 1'b1;					//into R3
	$display("Error, R3 should contain 18");
end


#60;	//HALT state takes 4 clock cycles to get to from IF1 but we set the delay to 6 clock cycles so that we can see if it stays in the halt state

if(TB.CPU.controller_fsm_1.present_state !== 5'b11111) begin //here we need to test whether the state machine stays
	err = 1'b1;					     //stays in the halt state
	$display("fsm should stay in halt stage");
end

if(err == 1'b0)
	$display("No Errors :)");

$stop;

end 

endmodule
