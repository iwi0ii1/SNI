bits 64
global _start
extern gdt_init
extern idt_init
extern paging_init
extern kmain

section .text
_start:
    mov rsp, stack_top
    and rsp, -16

    call gdt_init
    call idt_init
    call paging_init

    call kmain

.hang:
    hlt
    jmp .hang


section .bss
align 16
stack_bottom:       ; Lower address
    ; Tell NASM to reserve 4096 * 8 amount of bytes starting from label `stack_top`
    resb 4096 * 8
stack_top:          ; Higher address