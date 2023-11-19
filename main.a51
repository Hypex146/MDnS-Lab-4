;P0 - input
;P1 - state
;P2 - variant if succes
;R0 - previous key set
;R1 - N1
;R2 - N2
;R3 - N3
;R4 - N4
;R5 - shows changed bit
;R6 - register for calc


mov P0, #0ffh
mov P1, #01h
mov P2, #00h
mov R0, P0
mov R1, #05h


wait_input:
    mov A, P0
    xrl A, R0
    jnz process_input
    jmp wait_input


process_input:
    mov R0, P0
    mov R5, A
    mov A, P1
    cjne A, #01h, pi_1
    jmp state_1
pi_1:
    cjne A, #02h, pi_2
    jmp state_2
pi_2:
    cjne A, #03h, pi_3
    jmp state_3
pi_3:
    cjne A, #04h, failed
    jmp state_4


state_1:
    mov A, R5
    jb ACC.5, s1_1
    mov A, R1
    jz failed
    dec R1
    jmp wait_input
s1_1:
    mov P1, #02h
    mov A, R1
    clr C
    subb A, #03h
    jc s1_2
    mov A, R1
    clr C
    subb A, #03h
    mov R6, A
    jmp s1_3
s1_2:
    mov A, #03h
    clr C
    subb A, R1
    mov R6, A
s1_3:
    mov A, R6
    clr C
    subb A, #02h
    jc s1_4
    mov R2, #02h
    jmp s1_5
s1_4:
    mov A, R6
    mov R2, A
s1_5:
    jmp wait_input


state_2:
    mov A, R5
    jb ACC.4, s2_1
    mov A, R2
    jz failed
    dec R2
    jmp wait_input
s2_1:
    mov P1, #03h
    mov A, R1
    mov B, #03h
    mul AB
    mov R6, A
    mov A, R2
    mov B, #02h
    mul AB
    add A, R6
    mov B, #03h
    div AB
    mov R3, B
    jmp wait_input


state_3:
    mov A, R5
    jb ACC.1, s3_1
    mov A, R3
    jz failed
    dec R3
    jmp wait_input
s3_1:
    mov P1, #04h
    mov A, R1
    add A, R3
    mov R6, A
    clr C
    subb A, R2
    jc s3_2
    mov A, R6
    clr C
    subb A, R2
    mov R4, A
    jmp s3_3
s3_2:
    mov A, R2
    clr C
    subb A, R6
    mov R4, A
s3_3:
    jmp wait_input


state_4:
    mov A, R5
    jb ACC.0, passed
    mov A, R4
    jz failed
    dec R4
    jmp wait_input


failed:
    mov P1, #0AAh
    jmp $


passed:
    mov P1, #55h
    mov P2, #07h
    jmp $

end
