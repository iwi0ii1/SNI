bits 32
global sul_init

extern _start64

extern gdt_init
extern idt_init

section .bss
align 16
stack_bottom:       ; Lower address
    resb 4096 * 8
stack_top:          ; Higher address

section .text
sul_init:
    mov rsp, stack_top
    and rsp, -16

    call gdt_init
    call idt_init

    

    jmp _start64