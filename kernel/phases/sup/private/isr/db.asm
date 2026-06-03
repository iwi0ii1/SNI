; ISR of #DB (Debug)
%include "shared/vgatb.inc"

bits 64
global sup_isr_db

section .rodata
alert_msg: db "Kernel alert: Debug event triggered!", 0

section .text
sup_isr_db:
    cli

    push rax
    push rdi
    push rsi

    mov rdi, alert_msg
    mov sil, 0x0F
    call shared_vgatb_aputs

.done:
    pop rsi
    pop rdi
    pop rax

.hang:
    hlt
    jmp .hang