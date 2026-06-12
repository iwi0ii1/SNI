; Default ISR of #DE (Divide Error)
%include "phases/ecp/private/default_isr/shared.inc"

bits 64
global ecp_default_isr_de

section .rodata
error_msg: db "Kernel error: Divided by zero!", 0

section .text
ecp_default_isr_de:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp ecp_default_isr_shared_print_and_hang