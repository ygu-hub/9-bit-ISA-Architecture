// CSE141L
import Definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0]   Instruction,	   // machine code
  output logic  
          DataProcess,
          Branch    ,
          Link  ,
			    MemReadEn   ,	   // write to reg_file (common)
			    MemWriteEn   ,	   // write to mem (store only)
			    AluSrc  ,	   // Imeediate or register value?
          RegWriteEn,
			    Ack     // "done w/ program"
  //output logic[1:0] PCTarg
   //output logic[2:0]  ALU_inst
  );

/* ***** All numerical values are completely arbitrary and for illustration only *****
*/

// alternative -- case format
// always_comb	begin
// // list the defaults here
//    Branch    = 'b0;
//    BranchEn  = 'b0;
//    RegWrEn   = 'b1; 
//    MemWrEn   = 'b0;
//    LoadInst  = 'b0;
//    TapSel    = 'b0;     //
//    PCTarg    = 'b0;     // branch "where to?"
//    case(Instruction[8:6])  // list just the exceptions 
//      3'b000:   begin
//                   MemWrEn = 'b1;   // store, maybe
// 				  RegWrEn = 'b0;
// 			   end
//      3'b001:   LoadInst = 'b1;  // load
//      3'b010:   begin end
//      3'b011:   begin end
//      3'b100:   begin end
//      3'b101:   begin end
//      3'b110:   begin end
// // no default case needed -- covered before "case"
//    endcase
// end

// ALU commands
//assign ALU_inst = Instruction[2:0]; 
assign ALU_inst = Instruction[2:0];
assign AluSrc = &Instruction[2:0];

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????; // jump enable command to program counter / instruction fetch module on right shift command
// equiv to simply: assign Jump = Instruction[2:0] == RSH;
always_comb begin

    DataProcess = 'b0;
    Branch ='b0;
    Link ='b0;
		MemReadEn = 'b0;	   // write to reg_file (common)
		MemWriteEn ='b0;	   // write to mem (store only)
    RegWriteEn ='b1;

  case(Instruction[8:7])  // list just the exceptions 
    2'b00: //Data Processing
      begin DataProcess = 'b1; MemWriteEn ='b1; end
    2'b01: //Data Processing
      begin DataProcess = 'b1; MemWriteEn ='b1; end
    2'b11: //Branching
      begin Branch = 'b1;  
            RegWriteEn = 'b0;
      end 
    2'b10: //Data Transfer:
      begin 
        //Enable when storing = read from register -> memory
        RegWriteEn = !Instruction[0];
        MemReadEn = !Instruction[0];
        MemWriteEn = Instruction[0];
      end
        
  endcase

end


// whenever branch or jump is taken, PC gets updated or incremented from "Target"
//  PCTarg = 2-bit address pointer into Target LUT  (PCTarg in --> Target out
//assign PCTarg  = Instruction[3:2];
// reserve instruction = 9'b111111111; for Ack
assign Ack = &Instruction; // = ProgCtr == 385;

endmodule

