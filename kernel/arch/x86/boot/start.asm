bits 64
global _start
extern kmain
extern init_paging

section .text
_start:
    mov rsp, 0x300000
    and rsp, -16      ; Align for C ABI

    cli
    cld

    sub rsp, 24       ; Allocate stack of 16 bytes, and `call` pushes 8 bytes to stack

    mov [rsp],     rax
    mov [rsp + 8], rbx
    


    call init_paging



    mov rdi, [rsp]
    mov rsi, [rsp + 8]

    add rsp, 24        ; Free stack of 16 bytes, and `call` pushes 8 bytes to stack

    call kmain

.hang:
    hlt
    jmp .hang