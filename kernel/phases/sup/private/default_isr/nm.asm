; Default ISR of #DF (Double Fault)
%include "phases/sup/private/default_isr/shared.inc"

bits 64
global sup_default_isr_nm


section .rodata
alert_msg: db "Kernel alert: Device not available.", 0

section .text
sup_default_isr_nm:
    mov rdi, alert_msg
    mov sil, 0x0F

    jmp sup_default_isr_shared_print_and_hang