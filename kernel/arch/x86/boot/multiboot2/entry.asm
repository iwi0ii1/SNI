global _start
extern stack_top
extern main

section .text
_start:
    mov rsp, stack_top
    and rsp, -16
    
    call main

hang:
    hlt
    jmp hang