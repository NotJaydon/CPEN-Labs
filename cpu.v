module cpu(clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;

	wire [3:0] vsel;
	wire[15:0] instruc, sximm8, sximm5;
	wire [2:0] opcode, writenum, readnum, nsel;
	wire [1:0] op, shift, ALUop;
	wire write, loadb, loada, asel, bsel, loadc, loads;

instrucreg instrucreg_1 (.clk(clk), .in(in), .load(load), .out(instruc));	//Instantiating our instruction register which will store our input instructions

instrucDec instrucDec_1 (.in(instruc), .opcode(opcode), .op(op), .nsel(nsel),		//Instantiating our instruction decoder which will take our instruction bit field and dissect them into their respective external module inputs
.writenum(writenum), .readnum(readnum), .shift(shift), .sximm8(sximm8),
.sximm5(sximm5), .ALUop(ALUop));

datapath datapath_1(.clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb),		//from previous lab, is responsible for computation and storage
		    .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc),
		    .loads(loads), .writenum(writenum), .write(write), .sximm8(sximm8),
		    .sximm5(sximm5), .Z_out({N, V, Z}), .datapath_out(out),
		    .mdata({16{1'b0}}), .PC({8{1'b0}}));

controller_fsm controller_fsm_1(.clk(clk), .s(s), .reset(reset), .opcode(opcode), .op(op), .w(w),	//provides the inputs for the datapath to function correctly
	       .nsel(nsel), .vsel(vsel), .write(write), .loadb(loadb), .loada(loada),
	       .asel(asel), .bsel(bsel), .loadc(loadc), .loads(loads));

endmodule

