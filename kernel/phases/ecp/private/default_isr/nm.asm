; Default ISR of #DF (Double Fault)
%include "phases/ecp/private/default_isr/shared.inc"

bits 64
global ecp_default_isr_nm


section .rodata
alert_msg: db "Kernel alert: Device not available.", 0

section .text
ecp_default_isr_nm:
    mov rdi, alert_msg
    mov sil, 0x0F

    jmp ecp_default_isr_shared_print_and_hang