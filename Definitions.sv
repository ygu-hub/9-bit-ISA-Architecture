//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2022.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
// need > 8 instructions?
// typedef enum logic[3:0] and expand the list of enums
package Definitions;
    
// enum names will appear in timing diagram
// ADD = 3'b000; LSH = 3'b001; etc. 3'b111 is undefined here
  typedef enum logic[2:0] {
      XOR, ADD, SUB, MOV, AND, OR, SHF, MOVI } op_mne;
    

    // Instruction map
    const logic [2:0]KXOR  = 3'b000;
    const logic [2:0]KADD  = 3'b001;
    const logic [2:0]KSUB  = 3'b010;
    const logic [2:0]KMOV  = 3'b011;
    const logic [2:0]KAND  = 3'b100;
	  const logic [2:0]KOR  = 3'b101;
	  const logic [2:0]KSHF  = 3'b110;
    const logic [2:0]KMOVI = 3'b111;


endpackage // definitions
