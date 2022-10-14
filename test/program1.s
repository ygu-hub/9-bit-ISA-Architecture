# mem[63] = starting state
# mem[62] = tap pattern
# mem[61] = space
.set_r5_to_61
    MOVI r1 1
    MOVI r5 1  
    SHF r5 1
    ADD r5 r1
    SHF r5 1
    ADD r5 r1
    SHF r5 1
    ADD r5 r1
    SHF r5 1
    SHF r5 1
    ADD r5 r1


.set_r4_to_128
    MOVI r4 1  
    SHF r4 1
    ADD r4 r1
    SHF r4 1
    ADD r4 r1
    SHF r4 1
    ADD r4 r1
    SHF r4 1
    SHF r4 1
    ADD r4 r1
    ADD r4 r1
    ADD r4 r1
    ADD r4 r1
    SHF r4 1

.set_r6_to_127
    MOVI r6 1  
    SHF r6 1
    ADD r6 r1
    SHF r6 1
    ADD r6 r1
    SHF r6 1
    ADD r6 r1
    SHF r6 1
    SHF r6 1
    ADD r6 r1
    ADD r6 r1
    ADD r6 r1
    SHF r6 1
    ADD r6 r1



.lfsr_init

    # mem[129] = 127
    movi r1 1
    add r4 r1
    str r6 [r4]
    
    # set r0 = number of spaces
    ldr r0 [r5] 
    add r5 r1
    # set r2 = tap pattern
    ldr r2 [r5] 
    add r5 r1
    # set r3 = lfsr states
    ldr r3 [r5] 
    add r5 r1

    # r5 = 64 + num spaces
    add r5 r0

    # mem[130] = 64 + number of space;
    add r4 r1
    str r5 [r4]
    sub r5 r0
    
    # mem[131] = 0
    movi r0 0
    add r4 1
    str r0 [r4]
    sub r4 1

.loop
    # r0 = gen purpose
    # r1 = gen purpose, initially 1
    # r4 = initially 130
    # set r5 = memeory address to store, initially 64
    # r6 = terminating conditition, initially 127
    # set r7 = tap pattern & current state to get parity bits
    # mem[129] = 127
    # mem[130] = 64 + number of spaces
    bgt 0

.encrypt_space
    # r6 = mem[130]
    ldr r6 [r4]
    bge 1
    movi r7 0
    xor r7 r3
    str r7 [r5]

    # increment r5 and advance LFSR
    b 2

.encrypt_message
    # r6 = 127, r4 = 129  
    sub r4 r1
    ldr r6 [r4]

    # r4 = 131
    add r4 r1
    add r4 r1
    
    ldr r0 [r4]

    # get current orginal message and store in r7
    ldr r7 [r0]

    # encrypt and store
    xor r7 r3
    str r7 [r5]

    # increment r0 and store to 131
    add r0 r1
    str r0 [r4]

    # reset r4 to 130
    sub r4 r1


    b 3

.advance_LFSR
    # set r0 to 128
    MOVI r0 1  
    SHF r0 1
    ADD r0 r1
    SHF r0 1
    ADD r0 r1
    SHF r0 1
    ADD r0 r1
    SHF r0 1
    SHF r0 1
    ADD r0 r1
    ADD r0 r1
    ADD r0 r1
    ADD r0 r1
    SHF r0 1

    # r1 = mem[r0]
    mov r7 r3
    and r7 r2 
    ldr r1 [r0]
    shf r3 0

    or r3 r1
    movi r1 1
    add r5 r1
    b 4

.end