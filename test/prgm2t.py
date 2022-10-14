# init store all possible lfsr pattern from mem[129] - mem[138]
# init store all starting lfsr state mem[139] - mem[148]


# get the starting lfsr state = mem[64] xor 0 = mem[64] 


def LFSR_Advance(current, tap_pattern):
    #change r2
    print("current lfsr{} and tap ptn ".format(bin(current), bin(tap_pattern)))


encry = '!"$(1Bd)3FX1bKW.:uk-6l0`CFLY3fZ5j)''n<Yo>]zTpAb%*'
mem = {}
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

    mem[200] = 129
    mem[201] = 138
    mem[202] = 9
    mem[203] = 64
    mem[204] = 73
index = 0
# for i in range(64,73):
#     mem[i] = encry[index]

# init r3 = mem[64]

# lfsr tap pattern pointer: sp + 0 (starting at 130)
# lfsr tap pattern end address: sp  + 1 (always 138)


# lfsr loop end: sp + 2 (always 9)


# encode message index pointer： sp + 3 (starting at 64)
# encode message end pointer： sp + 4 (always at 73)



# decode message pointer: sp + 5 (starting at 0)
# decode message end pointer: sp + 6 (always at 63)
# encrypted message pointer: sp + 7 (starting at 64)
# encrypted message end pointer: sp + 8 (always at 127)



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
r2 = mem[r7]

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
    # r6 = mem[202] = always     r6 = mem[r7]
    r5 = 0

    while(r5 <= r6):
        # r7 = 203, r1 = current encode message index
        r7 = r7 + 1
        r1 = mem[r7]
        #r1 = current encode message xor current LFSR
        # r1 = mem[r1]
        # r1 = r1 ^ r2
        # r5 = r1, r6 = 0x20
        #If decryption value equal to space 0x20
        
        # update current lfsr, r7 = 200
        r7 = r0
        r3 = mem[r7]
        r3 = mem[r3]
        # r2 = current LFSR, r3 = current tap pattern
        LFSR_Advance(r2,r3)
        #print(hex(r3))
        
        r5 = r5 + 1
        
    # r5 = mem[sp + 0]
    # r5 = r5 + 1
    # mem[sp + 0] = r5
    r7 = r0
    r5 = mem[r7]
    r5 = r5 + 1
    mem[r7] = r5
    # r7 = 201
    r7 = r7 + 1
    r6 = mem[r7]


