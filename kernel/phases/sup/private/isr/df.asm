; ISR of #DF (Double Fault)
%include "phases/sup/private/isr/shared.inc"

bits 64
global sup_isr_df


section .rodata
error_msg: db "Kernel error: Double fault reached!!!", 0

section .text
sup_isr_df:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp sup_isr_shared_print_and_hang