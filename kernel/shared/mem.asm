bits 64
global hdp_shared_memcmp

section .text
hdp_shared_memcmp:
    mov rcx, rdx

.loop:
    test rcx, rcx
    je .equal

    mov al, [rdi]
    mov dl, [rsi]

    cmp al, dl
    jne .diff

    inc rdi
    inc rsi
    dec rcx
    jmp .loop

.equal:
    xor eax, eax
    ret

.diff:
    mov eax, 1
    ret