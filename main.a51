; P0 - input
; P1 - state
; P2 - variant if succes

; P3 - number of misses at this time (to del)
; P4 - maximum allowable number of misses at this time (to del)

; R0 - previous key (P0) set
; R1 - number of misses in the 1st state
; R2 - number of misses in the 2nd state
; R3 - number of misses in the 3rd state
; R4 - number of misses in the 4th state
; R5 - maximum allowable number of misses in current state (P1)
; R6 - shows changed bit
; R7 - register for calc (tmp register)


P4 EQU 0C0h  ; TODEL
mov P0, #0ffh
mov P1, #01h
mov P2, #00h
mov R0, P0
mov R1, #00h
mov R2, #00h
mov R3, #00h
mov R4, #00h
mov R5, #05h
mov P3, R1  ; TODEL
mov P4, R5  ; TODEL


wait_input:
    mov A, P0
    xrl A, R0
    jnz process_input
    jmp wait_input


process_input:
    mov R0, P0
    mov R6, A
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
    cjne A, #04h, pi_4
    jmp state_4
pi_4:
    jmp failed


state_1:
    mov A, R6
    jb ACC.5, s1_1
    mov A, R5
    clr C
    subb A, R1
    jnz s1_0
    jmp failed
s1_0:
    inc R1
    mov P3, R1  ; TODEL
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
    mov R7, A
    jmp s1_3
s1_2:
    mov A, #03h
    clr C
    subb A, R1
    mov R7, A
s1_3:
    mov A, R7
    clr C
    subb A, #02h
    jc s1_4
    mov R5, #02h
    jmp s1_5
s1_4:
    mov A, R7
    mov R5, A
s1_5:
    mov P3, R2  ; TODEL
    mov P4, R5  ; TODEL
    jmp wait_input


state_2:
    mov A, R6
    jb ACC.4, s2_1
    mov A, R5
    clr C
    subb A, R2
    jz failed
    inc R2
    mov P3, R2  ; TODEL
    jmp wait_input
s2_1:
    mov P1, #03h
    mov A, R1
    mov B, #03h
    mul AB
    mov R7, A
    mov A, R2
    mov B, #02h
    mul AB
    add A, R7
    mov B, #03h
    div AB
    mov R5, B
    mov P3, R3  ; TODEL
    mov P4, R5  ; TODEL
    jmp wait_input


state_3:
    mov A, R6
    jb ACC.1, s3_1
    mov A, R5
    clr C
    subb A, R3
    jz failed
    inc R3
    mov P3, R3  ; TODEL
    jmp wait_input
s3_1:
    mov P1, #04h
    mov A, R1
    add A, R3
    mov R7, A
    clr C
    subb A, R2
    jc s3_2
    mov A, R7
    clr C
    subb A, R2
    mov R5, A
    jmp s3_3
s3_2:
    mov A, R2
    clr C
    subb A, R7
    mov R5, A
s3_3:
    mov P3, R4  ; TODEL
    mov P4, R5  ; TODEL
    jmp wait_input


state_4:
    mov A, R6
    jb ACC.0, passed
    mov A, R5
    clr C
    subb A, R4
    jz failed
    inc R4
    mov P3, R4  ; TODEL
    jmp wait_input


failed:
    mov P1, #0AAh
    jmp $


passed:
    mov P1, #55h
    mov P2, #07h
    jmp $

end
