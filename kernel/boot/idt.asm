bits 64
global idt_init
global idt_ptr

section .bss
align 16
idt:
    resb 256 * 16

section .data
idt_ptr:
    dw 256 * 16 - 1
    dq idt



section .text
idt_init:
    ; example: zero IDT first
    mov rcx, 512
    lea rdi, [rel idt]
    xor rax, rax
    rep stosq

    lidt [idt_ptr]

    sti
    ret