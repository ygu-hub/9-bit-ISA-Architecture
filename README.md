## 9 bit ISA Architecture Python Assembler

Written in python, not optimized and not very orgianized.

Entry point in **/assembler/assembler.py.** This will take **/test/original_assembly.s** and assembles into **/test/converted_machinecode.txt** based on the layout defined in  **/assembler/inst_type.py.**.

The assembler will ignore any r,R,[,], and will replace any .label for branching.

*IMPORTANT*: The values of LUT will be given in stdout, be sure to copy these values before running the machine code if using branch.


## 9 bit ISA Architecture MOVI helper
Entry point in **/assembler/movi_helper.py**. This will quickly generate assembly code to move any 7 bit unsigned constant using shifts and adds, since the isa only allows for 2bit in the immediate field.

## TODO
Allows for C-like branching syntax?
Automatically assembles immediate moves if the values are too large?
