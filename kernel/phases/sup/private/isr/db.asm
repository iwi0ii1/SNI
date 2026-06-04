; ISR of #DB (Debug)
%include "phases/sup/private/isr/shared.inc"

bits 64
global sup_isr_db

section .rodata
alert_msg: db "Kernel alert: Debug event triggered!", 0

section .text
sup_isr_db:
    mov rdi, alert_msg
    mov sil, 0x0F

    jmp sup_isr_shared_print_and_hang