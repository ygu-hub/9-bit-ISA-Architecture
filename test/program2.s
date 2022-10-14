.value_init
    # stores 1 as constant
    movi r1 1

    # stores stack pointer
    mov r7 r0

    # stores current LFSR STATE, r7 = 203
    add r7 1
    add r7 1
    add r7 1

    # initialize current LFSR state = mem[64]
    ldr r2 [r7]
    ldr r2 [r2]
    
    # restore r7 to base pointer, r7 = 200
    mov r7 r0
    
    # r5 = mem[sp + 0] = starting at 129
    ldr r5 [r7]
    
    # r6 = mem[sp + 1] = always 137
    add r7 r1
    ldr r6 [r7]

.outer_loop
    bgt 15
    # r7 = 202
    mov r7 r0
    add r7 r1
    add r7 r1

    # r6 = mem[202] = always 9
    ldr r6 [r7]
    movi r5 0

    # r7 = 204, mem[r7] = 0
    add r7 r1
    add r7 r1
    str r5 [r7]

    #set flag to 1
    add r7 r1
    str r1 [r7]

.inner_loop
# restore r7 = 203
    mov r7 r0
    add r7 r1
    add r7 r1
    add r7 r1

    # r1 = current encode message index
    # r5 = current encode message xor current LFSR, r6 = 0x20
    ldr r1 [r7]
    ldr r1 [r1]
    xor r1 r2
    mov r5 r1
    movi r6 0

    # increment current encode message index for next loop: mem[203] = r1 + 1
    ldr r1 [r7]
    movi r3 1
    add r1 r3
    str r1 [r7]
    
    # restore r1 = 1
    movi r1 1

    # If decryption value NOT equal to space 0x20, then make the isValid = 0
    beq 6
    add r7 r1
    add r7 r1
    movi r1 0
    str r1 [r7]
    movi r1 1

.continue
    # update current lfsr, r7 = 200
    mov r7 r0
    ldr r3 [r7]
    ldr r3 [r3]


    # TODO:  put new LFSR into r2, give r3 = tap pattern, r2 = current state
    # r7 = 199
    sub r7 r1
    # get parity bit from mem[mem[r7]]
    and r3 r2
    ldr r1 [r7]
    ldr r1 [r1]
    shf r2 0
    or r2 r1

    # reset r1 and r7
    mov r7 r0
    movi r1 1


    add r7 r1
    add r7 r1
    ldr r6 [r7]

    add r7 r1
    add r7 r1
    ldr r5 [r7]
    add r5 r1
    str r5 [r7]

    ble 7

    # r7 = 203, mem[203] = 64, r5 = r5 - 10
    sub r7 r1
    ldr r5 [r7]
    
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1
    sub r5 r1

    str r5 [r7]

    # r7 = 205, check if isValid Flag = 1.
    add r7 r1
    add r7 r1
    ldr r5 [r7]
    mov r6 r1
    beq 2

    # r5 = mem[sp + 0]
    # r5 = r5 + 1
    # mem[sp + 0] = r5
    mov r7 r0
    ldr r5 [r7]
    add r5 r1
    str r5 [r7]

   
    # r7 = 201
    add r7 r1
    ldr r6 [r7]

    # r7 = 198, r2 = mem[mem[r7]] = mem[64]
    mov r7 r0
    sub r7 r1
    sub r7 r1
    ldr r2 [r7]
    ldr r2 [r2]

    b 9

.valid_tap_found
    # r3 = correct tap pattern, r7 = 200
    mov r7 r0
    ldr r3 [r7]
    ldr r3 [r3]

    # sp + 0 = write pointer (starting at 0)
    # sp + 1 = encode message pointer (starting at 64)
    # sp + 2 =  write pointer end (always 63)
   
    # r7 = 200, mem[200] = 0
    movi r2 0
    str r2 [r7]

    # 0100 0000
    # r1 = 64
    movi r1 1
    shf r1 1 
    shf r1 1 
    shf r1 1
    shf r1 1
    shf r1 1
    shf r1 1
    
    # r2 = 1
    movi r2 1

    # r7 = 201, mem[201] = 64
    mov r7 r0
    add r7 r2
    str r1 [r7]

    # r7 = 202, mem[202] = 63
    mov r7 r0
    add r7 r2
    add r7 r2
    sub r1 r2
    str r1 [r7]

    # Restore r1 = 1
    movi r1 1
    
    # Restore r2 = mem[64]
    mov r7 r0
    sub r7 r1
    sub r7 r1
    ldr r2 [r7]
    ldr r2 [r2]

# sp + 0 = write pointer (starting at 0)
# sp + 1 = encode message pointer (starting at 64)
# sp + 2 =  write pointer end (always 63)
.loop
    # r7 = 201, r1 = mem[201] = encrypted msg
    mov r7 r0
    add r7 r1
    ldr r1 [r7]
    ldr r1 [r1]

    # decode message and store to mem[200], r7 = 200
    mov r7 r0
    xor r1 r2
 
    ldr r7 [r7]
    str r1 [r7]

    # r2 = update next lfsr state
    movi r1 1
    mov r7 r0
    sub r7 r1

    mov r4 r3
    and r4 r2
    ldr r1 [r7]
    ldr r1 [r1]
    shf r2 0
    or r2 r1
    
    # update write pointer, r7 = 200
    mov r7 r0
    ldr r4 [r7]
    movi r1 1
    add r4 r1 
    str r4 [r7]

    # update encoded message pointer, r7 = 201
    mov r7 r0
    add r7 r1
    ldr r4 [r7]
    movi r1 1
    add r4 r1 
    str r4 [r7]

    # sp + 0 = write pointer (starting at 0)
    # sp + 1 = encode message pointer (starting at 64)
    # sp + 2 =  write pointer end (always 63)
    
    # r7 = 200
    mov r7 r0
    ldr r5 [r7] 
    
    # r7 = 202, r6 = 63
    mov r7 r0
    add r7 r1  
    add r7 r1  
    ldr r6 [r7]

    ble 8
    
.end
