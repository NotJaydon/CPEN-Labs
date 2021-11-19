module controller_fsm(s, reset, opcode, w, nsel, vsel, write, loada, loadb, asel, bsel, loadc, loads)
input s, reset;
input [1:0] op;
input [2:0] opcode;

output w, write, loada, loadb, asel, bsel, loadc, loads;
output [3:0] vsel;
output [2:0] nsel;

`define waitt 4'b0000
`define decode 4'b0001
`define geta 4'b1000 //you can change the state names to anything you want. wk 
`define getb 4'b1001
`define add 4'b1010
`define cmp 4'b1011
`define andd 4'b1100
`define nott 4'b1101
`define writereg 4'b1110
`define movim 4'b0100
`defife movrg1 4'0101
`define movrg2 4'0110
`define movrg3 4'0111

always @(posedge clk) begin

if(reset) begin
	present = `waitt;
end

else begin
   case(present) begin
	
	`waitt: if(s = 1'b1) 
		present = `decode;
		else
		present = `waitt;

	`decode: if(opcode = 3'b110)
			if(op = 2'b10)
			present = `movim;
			else if(op = 2'b00)
			present = `movrg;
			else 
			present = /*not sure*/
		else if (opcode = 3'b101)
			present = `geta;
		else 
		present = /* not sure*/

	`movim: present = `waitt;

	`movrg1: present = `movrg2:

	`movrg2: present = `movrg3;

	`movrg3: present = `waitt;


endcase
end
end

always @(*) begin
   case(present) begin

	`waitt: 

	`decode:

	`movim:  vsel = 4'b0100;
		 nsel = 3'b100;
		 write = 1'b1;
		 loadb = 1'bx;
		 loada = 1'bx;
		 asel = 1'bx;
		 bsel = 1'bx;
		 loadc = 1'bx;
		 loads = 1'bx;
		 w = 1'b0;


	`movrg1: vsel = 4'bxxx;
		 nsel = 3'bxxx;
		 write = 1'b0;
		 loadb = 1'b1;
		 loada = 1'b0;
		 asel = 1'b0;
		 bsel = 1'b0;
		 loadc = 1'b0;
		 loads = 1'b0;
		 w = 1'b0;

	`movrg2: vsel = 4'bxxx;
		 nsel = 3'bxxx;
		 write = 1'b0;
		 loadb = 1'b0;
		 loada = 1'b0;
		 asel = 1'b1;
		 bsel = 1'b0;
		 loadc = 1'b1;
		 loads = 1'b0;
		 w = 1'b0;

	`movrg3: vsel = 4'b0001;
		 nsel = 3'010;
		 write = 1'b1;
		 loadb = 1'bx;
		 loada = 1'bx;
		 asel = 1'bx;
		 bsel = 1'bx;
		 loadc = 1'b1;
		 loads = 1'b0;
		 w = 1'b0;
		 

endcase
end
endmodule
		