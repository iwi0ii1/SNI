bits 64
global hdp_shared_memcmp

section .text
hdp_shared_memcmp:
    push rbp
    mov rbp, rsp
    mov rcx, rdx        ; n
    mov rsi, rdi        ; s1
    mov rdi, rsi        ; s2

.lup:
    cmp rcx, 0
    je .equal
    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne .diff
    inc rsi
    inc rdi
    dec rcx
    jmp .lup

.equal:
    xor eax, eax
    pop rbp
    ret

.diff:
    mov eax, 1
    pop rbp    