// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

// includes package "Definitions"
// be sure to adjust "Definitions" to match your final set of ALU opcodes
import Definitions::*;

module ALU #(parameter W=8)(
  input        [W-1:0]   InputA,       // default from read_register_1
                         InputB,       // default from read_register_2
  input        [2:0]     Condition,         
  input        [2:0] OP,	           // ALU opcode, part of microcode
  input                  SC_in,        // shift or carry in
  output logic [W-1:0]   Out,          // data output
  output logic           Zero,         // output = zero flag    !(Out)
                         Parity,       // outparity flag        ^(Out)
                         Odd,          // output odd flag        (Out[0])
						 SC_out,
             condition_flag   // shift or carry out
  // you may provide additional status flags, if desired
  // comment out or delete any you don't need
);

always_comb begin
// No Op = default
// add desired ALU ops, delete or comment out any you don't need
  Out = 8'b0;				                        // don't need NOOP? Out = 8'bx
  SC_out = 1'b0;		 							// 	 will flag any illegal opcodes
  case(OP)
    KADD : {SC_out,Out} = InputA + InputB;   // unsigned add with carry-in and carry-out
    KSHF : Out = { InputB ? InputA[6] : 1'b0 ,InputA[5:0], 1'b0 };    // shift left, fill in with SC_in, fill SC_out with InputA[7]
// for logical left shift, tie SC_in = 0
    KXOR : Out = {1'b0, InputA[6:0] ^ InputB[6:0] }  ;                 // bitwise exclusive OR
    KAND : Out = InputA & InputB;                    // bitwise AND
    KOR : Out = InputA | InputB;
    KSUB : {SC_out,Out} = InputA + (~InputB) + 1;	// InputA - InputB;
    KMOV : Out = InputB;
    KMOVI : Out = InputB;
  endcase
end


always_comb begin


  case(Condition)
    //Branch Directly
    3'b000: condition_flag = 1'b1;
    //equal than
    3'b001: condition_flag = InputA == InputB;
    //greater than
    3'b010: condition_flag = InputA > InputB;
    //less than
    3'b011: condition_flag = InputA < InputB;
   //less than equal to
    3'b100: condition_flag = InputA <= InputB;
    //greater than equal to
    3'b101: condition_flag = InputA >= InputB;
    //not equal to
    3'b110: condition_flag = InputA != InputB;
    //NO Op/ Terminate
    3'b111: condition_flag = 1'b0;
  endcase
end


//XOR, ADD, SUB, MOV, AND, OR, SHF, MOVI

assign Zero   = ~|Out;                  // reduction NOR	 Zero = !Out; 
assign Parity = ^Out;                   // reduction XOR
assign Odd    = Out[0];                 // odd/even -- just the value of the LSB
endmodule
