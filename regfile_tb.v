`timescale 1ps/1ps

module regfile_tb;

reg [15:0] sim_data_in;
reg [2:0] sim_readnum, sim_writenum;
reg sim_clk, sim_write;
wire [15:0] sim_data_out;
reg err;


regfile DUT (

.data_in(sim_data_in),
.writenum(sim_writenum),
.write(sim_write),
.readnum(sim_readnum),
.clk(sim_clk),
.data_out(sim_data_out)
);


task checkreg; //one task to repeat with each register

input [15:0] task_data_in;
input [2:0] task_readnum; 
input [2:0] task_writenum;
input [7:0] task_load;


begin

sim_data_in = task_data_in;
sim_write = 1'b1;
sim_writenum = task_writenum;

#1;

if(regfile_tb.DUT.load !== task_load) begin
	$display("Error[%b:1]: load is %b, expected %b", task_readnum, regfile_tb.DUT.load, task_load);
	err = 1'b1;
end
#3;

sim_readnum = task_readnum;
//clk risedge
#2;

if(sim_data_out !== sim_data_in) begin
	$display("Error[%b:2]: data_out is %b, expected %b", task_readnum, sim_data_out, sim_data_in);
	err = 1'b1;
end

#1;

sim_write = 1'b0;
sim_data_in = 0;

#3;

if(sim_data_out == 1'd0) begin
	$display("Error[%b:3]: data_out should not have changed", task_readnum);
	err = 1'b1;
end

#6;  //clk change

if(sim_data_out == 1'd0) begin
	$display("Error[%b:4]: data_out should not have changed", task_readnum);
	err = 1'b1;
end
#4;

end
endtask

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

checkreg(16'b0000000000101010,3'b000,3'b000,8'b00000001);
checkreg(16'b0000000000100111,3'b001,3'b001,8'b00000010);

if(err == 1'b0)
	$display("No Errors :)");

$stop;

end
endmodule


