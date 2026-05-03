bits 64
global _start
extern main
extern init_paging

section .text
_start:
    ; 1. Hardcode Stack to 3MB
    mov rsp, 0x300000
    and rsp, -16      ; Align for C ABI

    cli
    cld

    ; 2. Pass Multiboot info to main (RDI = Pointer, RSI = Magic)
    mov rdi, rbx      
    mov rsi, rax

    ; 3. Initial Paging & Kernel
    call init_paging

    mov edi, eax    ; 1st arg: magic
    mov esi, ebx    ; 2nd arg: mb_addr
    call main

.hang:
    hlt
    jmp .hang