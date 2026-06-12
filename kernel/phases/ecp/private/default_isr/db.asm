; Default ISR of #DB (Debug)
%include "phases/ecp/private/default_isr/shared.inc"

bits 64
global ecp_default_isr_db

section .rodata
alert_msg: db "Kernel alert: Debug event triggered!", 0

section .text
ecp_default_isr_db:
    mov rdi, alert_msg
    mov sil, 0x0F

    jmp ecp_default_isr_shared_print_and_hang