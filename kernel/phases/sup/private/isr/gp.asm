; ISR of #GP (General Protection)
%include "shared/vgatb.inc"

bits 64
global sup_isr_gp

section .rodata
error_msg: db "Kernel error: General Protection Fault!", 0

section .text
sup_isr_gp:
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