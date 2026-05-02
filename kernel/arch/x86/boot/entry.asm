bits 64
global _start

section .text
_start:
    mov rsp, stack_top
    and rsp, -16

    cli
    cld

    call init_paging
    call main

.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top: