module controller_fsm(mem_cmd, load_pc, load_ir, reset_pc, addr_sel, load_addr, clk, reset, opcode, op, nsel, vsel, write, loada, loadb, asel, bsel, loadc, loads);
input [2:0] opcode;
input [1:0] op;
input reset, clk;
//need to add additional outputs - resolved

//compiler doesn't pick up width errors - need to check

output [3:0] vsel;
output [2:0] nsel;	//specified in the pdf that nsel was 2 bits wide but I think we can leave it as is
output [1:0] mem_cmd;
output write, loada, loadb, asel, bsel, loadc, loads, load_pc, load_ir, reset_pc, addr_sel, load_addr;

//Use these definitions for M commands in lab 7 top
`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b11

`define RST 5'b00000
`define IF1 5'b00001
`define IF2 5'b00010
`define UpdatePC 5'b00011
`define decode 5'b00100
`define geta 5'b00101
`define getb 5'b00110
`define arithmetic 5'b00111
`define writereg 5'b01000
`define movimm 5'b01001
`define movreguno 5'b01010
`define movregdos 5'b01011
`define movregtres 5'b01100
`define compare 5'b01101
`define arithmetic2_0 5'b01110
`define buff1 5'b01111
`define buff2 5'b10000
`define load 5'b10001
`define str1 5'b10010
`define str2 5'b10011
`define strval 5'b10100
`define halt 5'b11111

//Make states for MNONE, MREAD, MWRITE - resolved

wire [4:0] present_state, state_next_reset, state_next;
reg [25:0] next;	//change the width of next - resolved

vDFF #(5) STATE(.clk(clk), .in(state_next_reset), .out(present_state)); //simple flipflop module to change 
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
		//state, vsel, nsel, write, loadb, loada, asel, bsel, loadc, loads, reset_pc, load_pc, addr_sel, mem_cmd, load_ir, load_addr
   casex({present_state, op, opcode}) //checking state and inputs
	//Reset state where we will reset the program counter by loading all 0's into the PC register
	{`RST, 2'bxx, 3'bxxx}: next <= {`IF1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, `MNONE, 1'b0, 1'b0};
	//first stage of instruction fetch. PC register contains the address of the next instruction in RAM and we select this in the multiplexer
	{`IF1, 2'bxx, 3'bxxx}: next <= {`IF2, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `MREAD, 1'b0, 1'b0};
	//second stage in which the contents of the read address now appear on the read_data line. IR is loaded with this information/command
	{`IF2, 2'bxx, 3'bxxx}: next <= {`UpdatePC, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `MREAD, 1'b1, 1'b0};
	//next_pc already had the address of the next instruction to be executed so we clock to load this new address into the PC register
	{`UpdatePC, 2'bxx, 3'bxxx}: next <= {`decode, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `MNONE, 1'b0, 1'b0};
	
	/*a string of decode stages. if the opcode is 101, 011 or 100, we move to get a which is a common starting point
	 *for the ALU, LDR and STR instructions. If 110, we move to either the starting state of move immediate
	 *or move register contents based on the op "code" given. Finally, if opcode is 111, we go to the halt state
	 */
	{`decode, 2'bxx, 3'b101}: next <= {`geta, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`decode, 2'bxx, 3'b011}: next <= {`geta, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`decode, 2'bxx, 3'b100}: next <= {`geta, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`decode, 2'b10, 3'b110}: next <= {`movimm, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`decode, 2'b00, 3'b110}: next <= {`movreguno, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`decode, 2'bxx, 3'b111}: next <= {`halt, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	
	//halt state which will cause the PC to no longer be updated. Can only leave this state from rst going high
	{`halt, 2'bxx, 3'bxxx}: next <= {`halt, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	
	/*a string of geta states due to the fact that there were multiple pointers to this state from the decode stage
	 *Once again, depending on the opcode, we either go to getb which sets our path in the ALU stage or arithmetic2_0
	 *where our path will be set to either a load or a store
	 */
	{`geta, 2'bxx, 3'b101}: next <= {`getb, 4'bxxxx, 3'b100, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0, 1'b0};
	{`geta, 2'bxx, 3'b011}: next <= {`arithmetic2_0, 4'bxxxx, 3'b100, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0, 1'b0};
	{`geta, 2'bxx, 3'b100}: next <= {`arithmetic2_0, 4'bxxxx, 3'b100, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, `MNONE, 1'b0, 1'b0};
	/*A string of getb states all within the path ALU instruction path. There are 4 because if the opcode is 01, then we jump to a compare stage
	 *which is unique to that specific opcode. Therefore, we could not apply 2'bxx for the opcode in this regard
	 */
	{`getb, 2'b00, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`getb, 2'b10, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`getb, 2'b11, 3'bxxx}: next <= {`arithmetic, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	{`getb, 2'b01, 3'bxxx}: next <= {`compare, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//basic arithmetic stage for the ALU instruction path. In this state, operations will only be performed on loaded values from the regfile
	{`arithmetic, 2'bxx, 3'bxxx}: next <= {`writereg, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b1};
	//final stage of the ALU isntruction path in which the result stored in the C register is written to a register in the regfile
	{`writereg, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0001, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};	//not sure aobut IF1
	
	//Only stage in the move immmediate instruction path after decode. The immediate value is stored within the instruction itself and all that is
	//done here is a selection at the input mux of the regfile to load this immediate value into the appropriate register
	{`movimm, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0100, 3'b100, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};	//not sure aobut IF1

	/*the arithmetic stage for the LDR/STR instruction path. At this point we have already retrieved the contents of register Rn and are storing the result
	 *of its addition to sximm5 in the C register. When clock rises, this content will be on datapath_out
	 */
	{`arithmetic2_0, 2'bxx, 3'bxxx}: next <= {`buff1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//two buff1 states from which we will either branch to the LDR or STR instruction paths depending on the opcode. At this point we set load_addr to 1
	//since we need to store a portion of the contents of datapath out in the data address register. Also addr_sel is 0 as it also is in the following state
	//since we would like to pass the output of this register to the mem_addr line
	{`buff1, 2'bxx, 3'b011}: next <= {`buff2, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b1};
	{`buff1, 2'bxx, 3'b100}: next <= {`str1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b1};
	
	/*now we are stuck on the LDR instruction path. We output a MEM command of read so that we can read the data correspinding to the given address
	 *The data read from memory will appear on the read_data line. 
 	 */	
	{`buff2, 2'bxx, 3'bxxx}: next <= {`load, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MREAD, 1'b0, 1'b0};
	//the data now appears on the read_data line and we choose vsel such that this line is the input to the register file. We store the result
	//in the register specified as Rd
	{`load, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b1000, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MREAD, 1'b0, 1'b0}; //not sure if addr_sel can be x now

	/*now we are stuck on the STR path. At this point, we have stored the address and it is on the read/write adress line.
	 *now, we load register B with the contents of the register specified as Rd.
	 */
	{`str1, 2'bxx, 3'bxxx}: next <= {`str2, 4'bxxxx, 3'b010, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//in this stage, we set asel as 1 since we do not want to alter the contents of Rd on its way to the output of register C
	{`str2, 2'bxx, 3'bxxx}: next <= {`strval, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//at this point c has been loaded with the contents of the register and these contents appear on datapath_out
	//we set the MEM command to write so that we can write this data into the address that was previously held on the
 	//write_address line
	{`strval, 2'bxx, 3'bxxx}: next <= {`IF1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MWRITE, 1'b0, 1'b0};
	
	//first stage of move register contents to another. We set loadb to 1 since we have the option to perform shift operations and whatnot
	{`movreguno, 2'bxx, 3'bxxx}: next <= {`movregdos, 4'bxxxx, 3'b001, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//now that b is loaded, we set asel to 1 since we want to preserve the value of the contents in register b
	{`movregdos, 2'bxx, 3'bxxx}: next <= {`movregtres, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};
	//now the contents of the read register appear on datapath out and we select vsel accordingly to select this as the input to our register file to move to the specified register
	{`movregtres, 2'bxx, 3'bxxx}: next <= {`IF1, 4'b0001, 3'b010, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};	//not sure aobut IF1

	//This is our compare stage which branches from our getb stage as outlined earlier. Basically this extra state has been added to ensure that no register is written to when we compare
	//two values, so we set write to 0 unlike in the regular write_reg which has write set to 1
	{`compare, 2'bxx, 3'bxxx}: next <= {`IF1, 4'bxxxx, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, `MNONE, 1'b0, 1'b0};	//not sure aobut IF1
	default: next = {26{1'bx}};
    endcase
end

assign {state_next, vsel, nsel, write, loadb, loada, asel, bsel, loadc, loads, reset_pc, load_pc, addr_sel, mem_cmd, load_ir, load_addr} = next;	//assigning all of the FSM outputs from the next input

endmodule
		