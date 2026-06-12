; Default ISR of #DF (Double Fault)
%include "phases/ecp/private/interrupts/default_isr/shared.inc"

bits 64
global ecp_default_isr_df


section .rodata
error_msg: db "Kernel error: Double fault reached!!!", 0

section .text
ecp_default_isr_df:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp ecp_default_isr_shared_print_and_hang