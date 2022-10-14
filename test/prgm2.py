# init store all possible lfsr pattern from mem[129] - mem[138]
# init store all starting lfsr state mem[139] - mem[148]


# get the starting lfsr state = mem[64] xor 0 = mem[64] 


def LFSR_Advance(current, tap_pattern):
    #change r2
    r2 = r2 + 1
    print("current lfsr{} and tap ptn ".format(bin(current), bin(tap_pattern)))


encry = '!"$(1Bd)3FX1bKW.:uk-6l0`CFLY3fZ5j)''n<Yo>]zTpAb%*'
mem = {}

#   core[129] <= 'h60;
#   	core[130] <= 'h48;  
#     core[131] <= 'h78;
#     core[132] <= 'h72;
#     core[133] <= 'h6A;
#     core[134] <= 'h69;
#     core[135] <= 'h5C;
#     core[136] <= 'h7E;
#     core[137] <= 'h7B;
#     core[198] <= 'd64;
#     core[199] <= 'd128;
#     core[200] <= 'd129;
#     core[201] <= 'd137;
#     core[202] <= 'd9;
#     core[203] <= 'd64;
#     core[204] <= 'd73;
#     core[205] <= 'd1;
for i in range(257):
    mem[i] = 0
    mem[129] = 0x60
    mem[130] = 0x48
    mem[131] = 0x78
    mem[132] = 0x72
    mem[133] = 0x6A
    mem[134] = 0x69
    mem[135] = 0x5C
    mem[136] = 0x7E
    mem[137] = 0x7B

    mem[198] = 64
    mem[199] = 128
    mem[200] = 129
    mem[201] = 137
    mem[202] = 9
    mem[203] = 64
    mem[204] = 73
    mem[205] = 1
index = 0
for i in range(64,74):
    mem[i] = encry[index]
    index = index +1

# init r3 = mem[64]



# lfsr tap pattern pointer: sp + 0 (starting at 129)
# lfsr tap pattern end address: sp  + 1 (always 137)

# lfsr loop end: sp + 2 (always 9)
# lfsr current loop index： sp + 4 (starting at 0)

# encode message index pointer： sp + 3 (starting at 64)

# tap pattern isValid flag: sp + 5 (starting at 1, 0 if the current tap pattern is invalid)

# decode message pointer: sp + 6 (starting at 0)
# decode message end pointer: sp + 7 (always at 63)
# encrypted message pointer: sp + 8 (starting at 64)
# encrypted message end pointer: sp + 9 (always at 127)



# init stack pointer r7 = 200
# init r0 as the stack base pointer 200, DONT CHANGE

r0 = 200

#stores 1 as constant
r1 = 1

#stores stack pointer
r7 = 200

#stores current LFSR STATE, r7 = 203
r7 = r7 + r1
r7 = r7 + r1
r7 = r7 + r1


r2 = 0

#restore r7 to base pointer, r7 = 200
r7 = r0

# r5 = mem[sp + 0] = starting at 129
r5 = mem[r7]
# r6 = mem[sp + 1] = always 138
r7 = r7 + r1


r6 = mem[r7]

while (r5 <= r6):
    # r7 = 202
    r7 = r0
    r7 = r7 + r1
    r7 = r7 + r1
    # r6 = mem[202] = always 9
    r6 = mem[r7]
    r5 = 0
    # r7 = 204, mem[r7] = 0
    r7 = r7 + r1
    r7 = r7 + r1
    mem[r7] = r5
    #set flag to 1
    r7 = r7 + r1
    mem[r7] = r1

    while(r5 <= r6):
        # restore r7 = 203
        r7 = r0
        r7 = r7 + r1
        r7 = r7 + r1
        r7 = r7 + r1

        # r1 = current encode message index
        # r5 = current encode message xor current LFSR, r6 = 0x20
        r1 = mem[r7]
        r1 = mem[r1]
        r1 = ord(r1) ^ r2
        r5 = r1
        r3 = 0x20
        r6 = r3
        
        # increment current encode message index for next loop: mem[203] = r1 + 1
        r1 = mem[r7]
        r3 = 1
        r1 = r1 + r3
        mem[r7] = r1
        print(r1)

        # restore r1 = 1
        r1 = 1

        #if(mem[200] == 132):
            #r5 = r6
        #If decryption value NOT equal to space 0x20, then make the isValid = 0
        if(r5!=r6):
            # r7 = 205
            r7 = r7 + 1
            r7 = r7 + 1
            mem[r7] = 0
        
        # update current lfsr, r7 = 200
        r7 = r0
        r3 = mem[r7]
        r3 = mem[r3]
        # r2 = current LFSR, r3 = current tap pattern
        #LFSR_Advance(r2,r3)
        r2 = r2 + 1
        print( "Current tap ptn {}, current state {} " .format(hex(r3), r2))
        
        # r7 = 202
        r7 = r0
        r7 = r7 + r1
        r7 = r7 + r1
        # r6 = mem[202] = always 9
        r6 = mem[r7]

        # r7 = 204, restore r5 to the current index of the inner while loop
        r7 = r7 + r1
        r7 = r7 + r1
        r5 = mem[r7]
        r5 = r5 + r1
        mem[r7] = r5
    #r7 = 203, mem[203] = 64
    r7 = r7 - r1
    r5 = mem[r7]
    r5 = r5 - 10
    mem[r7] = r5

    #r7 = 205, check if isValid Flag = 1.
    r7 = r7 + r1
    r7 = r7 + r1
    r5 = mem[r7]
    r6 = r1
    if(r5 == r6):
        break

    # r5 = mem[sp + 0]
    # r5 = r5 + 1
    # mem[sp + 0] = r5
    r7 = r0
    r5 = mem[r7]
    r5 = r5 + r1
    mem[r7] = r5
    # r7 = 201
    r7 = r7 + r1
    r6 = mem[r7]
    r2 = 0

#r7 = r0
print(hex(mem[mem[200]]))