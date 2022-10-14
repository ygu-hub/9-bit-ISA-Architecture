// skeletal starter code top level of your DUT

import Definitions::*;

module top_level(
  input clk, init, req,
  output logic ack
  );

  wire [ 9:0] PgmCtr, PCTarg;  
  logic Branch, Zero, condition_flag, SC_in, Parity, Odd, SC_out, BranchRelEn, Jump, DataProcess, Link, MemReadEn, MemWriteEn,AluSrc,AluOp,RegWriteEn;
  wire [ 8:0] Instruction;   // our 9-bit opcode
  wire [2:0] ReadAddrA, ReadAddrB;
  wire [ 7:0] ReadA, ReadB;  // reg_file outputs
  wire [ 7:0] InA, InB,    // ALU operand inputs
            ALU_out;       // ALU result
  wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
 
assign BranchAbs = 'b0;

InstROM #(.W(9),.A(10)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
	);



Immediate_LUT  #(.PC_width(10)) LUT(
  .addr(Instruction[3:0]),
  .datOut(PCTarg)
  );


// assign PCTarg = BranchRegOut;

InstFetch IF1 (		       // this is the program counter module
	.Reset        (init   ) ,  // reset to 0
	.Start        (ack   ) ,  // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (clk     ) ,  //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchAbs    (BranchAbs    ) ,  // jump enable
	.BranchRelEn  (Branch) ,  // branch enable
	.ALU_flag	  (condition_flag    ) ,  // 
  .Target       (PCTarg ) ,  // "where to?" or "how far?" during a jump or branch
	.ProgCtr      (PgmCtr  )	   // program count = index to instruction memory
	);			




// // populate with program counter, instruction ROM, reg_file (if used),
// //  accumulator (if used), 
assign MemWriteValue = ReadA;

DataMem DM(.Clk         (clk), 
           .Reset       (init), 
           .WriteEn     (MemWriteEn), 
           .DataAddress (DataProcess ? 8'd128 : ReadB), 
           .DataIn      (DataProcess ? Parity :MemWriteValue), 
           .DataOut     (MemReadValue));


assign RegWriteValue =  MemReadEn ? MemReadValue : ALU_out;
assign ReadAddrA = DataProcess ? Instruction[7:5] : (Branch ? 3'b101 :  Instruction[6:4]);
assign ReadAddrB = DataProcess ? Instruction[4:3] : (Branch ? 3'b110 :  Instruction[3:1]);


RegFile #(.W(8),.D(3)) RF1 (			  // D(3) makes this 8 elements deep
		.Clk   (clk) 				  ,
    .Reset   (init),
		.WriteEn   (RegWriteEn)    , 
		.RaddrA    (ReadAddrA),        //concatenate with 0 to give us 4 bits
		.RaddrB    (ReadAddrB), 
		.Waddr     (DataProcess ? Instruction[7:5] : Instruction[6:4]), 	      // mux above
		.DataIn    (RegWriteValue) , 
		.DataOutA  (ReadA        ) , 
		.DataOutB  (ReadB		 )
	);


    Ctrl Ctrl1 (
    .Instruction,
    .DataProcess,
    .Branch    ,
    .Link  ,
		.MemReadEn   ,	   // write to reg_file (common)
		.MemWriteEn   ,	   // write to mem (store only)
		.AluSrc  ,	   // Imeediate or register value?
    .RegWriteEn,
		.Ack(ack)	
  );

assign InA = ReadA;
assign InB = (DataProcess & (Instruction[2:0] == 3'b111 | Instruction[2:0] == 3'b110 )) ? {6'b0, Instruction[4:3]} : ReadB;

ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
    .Condition (Instruction[6:4]),
	  .SC_in   (1'b0),
	  .OP      (Instruction[2:0]),
	  .Out     (ALU_out),//regWriteValue),
	  .Zero,
    .Parity,
    .Odd,
    .SC_out,
    .condition_flag
);




// temporary circuit to provide ack (done) flag to test bench
//   remove or greatly increase the match value once you get a 
//   proper ack 
// always @(posedge clk) 
//   if(reset == 'b1) 
//     PgmCtr <= 'h0;
//   else  
// 	  PgmCtr <= PgmCtr+'h1;

// assign ack = PgmCtr=='h256;  // pctr needed to trigger ack (arbitary time)

endmodule

