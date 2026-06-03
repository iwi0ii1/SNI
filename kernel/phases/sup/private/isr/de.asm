; ISR of #DE (Divide Error)
%include "shared/vgatb.inc"

bits 64
global sup_isr_de

section .rodata
error_msg: db "Kernel error: Divided by zero!", 0

section .text
sup_isr_de:
    cli

    push rax
    push rdi
    push rsi

    mov rdi, error_msg
    mov sil, 0x0F
    call shared_vgatb_aputs

.done:
    pop rsi
    pop rdi
    pop rax

.hang:
    hlt
    jmp .hang