bits 64
global hdp_shared_memcmp

section .text
hdp_shared_memcmp:
    push rbp
    mov rbp, rsp

    mov rcx, rdx        ; n
    mov rsi, rdi        ; s1 (WRONG in your code!)

.lup:
    test rcx, rcx
    je .equal
    mov al, [rdi]       ; load from s1
    mov bl, [rsi]       ; load from s2
    cmp al, bl
    jne .diff
    inc rdi
    inc rsi
    dec rcx
    jmp .lup

.equal:
    xor eax, eax        ; return 0
    pop rbp
    ret

.diff:
    mov eax, 1          ; return nonzero
    pop rbp
    ret