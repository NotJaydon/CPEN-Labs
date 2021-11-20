module controller_fsm(clk, s, reset, opcode, op, w, nsel, vsel, write, loada, loadb, asel, bsel, loadc, loads);
input s, reset, clk;
input [1:0] op;
input [2:0] opcode;

output w, write, loada, loadb, asel, bsel, loadc, loads;
output [3:0] vsel;
output [2:0] nsel;

`define wait_ 4'b0000
`define decode 4'b0001
`define geta 4'b1000 //you can change the state names to anything you want. wk 
`define getb 4'b1001
`define arithmetic 4'b1010
`define writereg 4'b1110
`define movimm 4'b0100
`define movreguno 4'b0101
`define movregdos 4'b0110
`define movregtres 4'b0111

wire [3:0] present_state, state_next_reset, state_next;
reg [18:0] next;

vDFF #(4) STATE(.clk(clk), .in(state_next_reset), .out(present_state));

assign state_next_reset = reset ? `wait_ : state_next;

//vsel - will not do anything if write is 0
//nsel - will not do anything if write is 0 and also if load a and load b are zero
//write - we need to either make this a 1 or a 0
//loadb & loada - need to make this a one or a zero
//asel - can be anything if loadc is zero
//bsel - can be anything if loadc is zero
//loadc - need to make either 1 or 0
//loads - for now we think that we only set this in the compare state
//w - needs to be 1 or 0 and is local to this current module

always @* begin	//state, vsel, nsel, write, loadb, loada, asel, bsel, loadc, loads, w
   casex({present_state, op, opcode, s})
	{`wait_, 2'bxx, 3'bxxx, 1'b1}: next = {`decode, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`wait_, 2'bxx, 3'bxxx, 1'b0}: next = {`decode, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b1};
	{`decode, 2'bxx, 3'b101, 1'bx}: next = {`geta, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`decode, 2'b10, 3'b110, 1'bx}: next = {`movimm, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`decode, 2'b00, 3'b110, 1'bx}: next = {`movreguno, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	
	{`geta, 2'bxx, 3'bxxx, 1'bx}: next = {`getb, 4'bxxxx, 3'b100, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`getb, 2'bxx, 3'bxxx, 1'bx}: next = {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`arithmetic, 2'bxx, 3'bxxx, 1'bx}: next = {`writereg, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0};
	{`writereg, 2'bxx, 3'bxxx, 1'bx}: next = {`wait_, 4'b0001, 3'b101, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	
	{`movimm, 2'bxx, 3'bxxx, 1'bx}: next = {`wait_, 4'b0100, 3'b100, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	
	{`movreguno, 2'bxx, 3'bxxx, 1'bx}: next = {`movregdos, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	{`movregdos, 2'bxx, 3'bxxx, 1'bx}: next = {`movregtres, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0};
	{`movregtres, 2'bxx, 3'bxxx, 1'bx}: next = {`wait_, 4'b0001, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0};
	default: next = {19{1'bx}};
    endcase
end
endmodule
		