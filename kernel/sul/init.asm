bits 64
global sul_init

extern gdt_init
extern idt_init
extern paging_init

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
    call paging_init

    ret