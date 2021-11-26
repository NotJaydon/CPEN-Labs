module controller_fsm(mem_cmd, load_pc, load_ir, reset_pc, addr_sel, clk, reset, opcode, op, nsel, vsel, write, loada, loadb, asel, bsel, loadc, loads);
input [2:0] opcode;
input [1:0] op;
input reset, clk;
//need to add additional outputs - resolved

//compiler doesn't pick up width errors - need to check

output [3:0] vsel;
output [2:0] nsel;	//specified in the pdf that nsel was 2 bits wide but I think we can leave it as is
output [1:0] mem_cmd;
output write, loada, loadb, asel, bsel, loadc, loads, load_pc, load_ir, reset_pc, addr_sel;

//Use these definitions for M commands in lab 7 top
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b11

`define RST 4'b0000
`define IF1 4'b0001
`define IF2 4'b0010
`define UpdatePC 4'b0011
`define decode 4'b0100
`define geta 4'b0101
`define getb 4'b0110
`define arithmetic 4'b0111
`define writereg 4'b1000
`define movimm 4'b1001
`define movreguno 4'b1010
`define movregdos 4'b1011
`define movregtres 4'b1100
`define compare 4'b1101

//Make states for MNONE, MREAD, MWRITE - resolved

wire [3:0] present_state, state_next_reset, state_next;
reg [23:0] next;	//change the width of next - resolved

vDFF #(4) STATE(.clk(clk), .in(state_next_reset), .out(present_state)); //simple flipflop module to change 
									//states on risedge of clock

assign state_next_reset = reset ? `RST : state_next; //checks to see if reset is high (in which case we go back to beginning)

//vsel - will not do anything if write is 0
//nsel - will not do anything if write is 0 and also if load a and load b are zero
//write - we need to either make this a 1 or a 0
//loadb & loada - need to make this a one or a zero
//asel - can be anything if loadc is zero
//bsel - can be anything if loadc is zero
//loadc - need to make either 1 or 0
//loads - for now we think that we only set this in the compare state
//w - needs to be 1 or 0 and is local to this current module

always @* begin	//continuously updates present state and outputs based on the past state and inputs
		//state, vsel, nsel, write, loadb, loada, asel, bsel, loadc, loads, reset_pc, load_pc, addr_sel, mem_cmd, load_ir
   casex({present_state, op, opcode}) //checking state and inputs
	{`RST, 2'bxx, 3'bxxx}: next <= {`IF1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b1, 1'b1, 1'bx, `MNONE, 1'b0};	//Not sure but for now, addr_sel is 1'bx, could be 0 as shown in diagram
	{`IF1, 2'bxx, 3'bxxx}: next <= {`IF2, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `MREAD, 1'b0};	//addr_sel state NOT RESOLVED
	{`IF2, 2'bxx, 3'bxxx}: next <= {`UpdatePC, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `MREAD, 1'b1};
	{`UpdatePC, 2'bxx, 3'bxxx}: next <= {`decode, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, `MNONE, 1'b0};
	{`decode, 2'bxx, 3'b101}: next <= {`geta, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`decode, 2'b10, 3'b110}: next <= {`movimm, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`decode, 2'b00, 3'b110}: next <= {`movreguno, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	
	{`geta, 2'bxx, 3'bxxx}: next <= {`getb, 4'bxxxx, 3'b100, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`getb, 2'b00, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`getb, 2'b10, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`getb, 2'b11, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`getb, 2'b01, 3'bxxx}: next <= {`compare, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`arithmetic, 2'bxx, 3'bxxx}: next <= {`writereg, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`writereg, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0001, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};	//not sure aobut IF1
	
	{`movimm, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0100, 3'b100, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};	//not sure aobut IF1
	
	{`movreguno, 2'bxx, 3'bxxx}: next <= {`movregdos, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`movregdos, 2'bxx, 3'bxxx}: next <= {`movregtres, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};
	{`movregtres, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0001, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};	//not sure aobut IF1

	{`compare, 2'bxx, 3'bxxx}: next <= {`IF1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0};	//not sure aobut IF1
	default: next = {24{1'bx}};
    endcase
end

assign {state_next, vsel, nsel, write, loadb, loada, asel, bsel, loadc, loads, reset_pc, load_pc, addr_sel, mem_cmd, load_ir} = next;

endmodule
		