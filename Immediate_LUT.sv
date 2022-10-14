/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module Immediate_LUT #(PC_width = 10)(
  input               [ 3:0] addr,
  output logic[PC_width-1:0] datOut
  );

always_comb begin
  datOut = 'h001;	          // default to 1 (or PC+1 for relative)
  case(addr)		   
	4'b0000:   datOut = 41;   // -4, i.e., move back 16 lines of machine code
  4'b0001:   datOut = 5;
  4'b0010:   datOut = 13;
  4'b0011:   datOut = 1;
  4'b0100:   datOut = -40;
  4'b0101:   datOut = 197;
  4'b0110:   datOut = 6;
  4'b0111:   datOut = -39;
  4'b1000:   datOut = -34;
  4'b1001:   datOut = -80;
  4'b1010:   datOut = 17;
  4'b1011:   datOut = -24;
  4'b1100:   datOut = 4;
  4'b1101:   datOut = 5;
  4'b1110:   datOut = -53;
  4'b1111:   datOut = 143;
  endcase
end
//41, 5, 13, 1, -40, 143, 6, -39, 13, -80, -34




//[41, 5, 13, 1, -40, 197, 6, -39, 13, -80, 17, -24, 4, 5, -53]


//[41, 5, 13, 1, -40, 178, 6, -39, 13, -80, 17, -24, -34]
//[41, 5, 13, 1, -40, 160, 6, -39, 13, -80, -16, -34]
//[41, 5, 13, 1, -40, 167, 6, -39, 13, -80, 17, -23, -34]
//41, 5, 13, 1, -40, 166, 6, -39, 13, -80, -22, -34
endmodule
//[98, 6, -39, 13, -80]
			 // 3fc = 1111111100 -4
			 // PC    0000001000  8
			 //       0000000100  4  [18, 5, 6, 1, -17]


       // 34, 5, 8, 1, -33
//[42, 5, 14, 1, -41

//70, 6, -32, 9, -69

//85, 6, -44, 12, -84

//86, 6, -44, 13, -85
//87, 6, -45, 13, -86

//81, 6, -39, 13, -80

//[139, 6, -39, 13, -80, -33]

//138, 6, -39, 13, -80, -32

//[41, 5, 13, 1, -40, 143, 6, -39, 13, -80, -34]

//[41, 5, 13, 1, -40, 176, 6, -39, 13, -80, 17, -23, -34]