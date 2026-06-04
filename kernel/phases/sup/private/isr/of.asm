; ISR of #OF (OverFlow)
%include "phases/sup/private/isr/shared.inc"

bits 64
global sup_isr_of

section .rodata
error_msg: db "Kernel error: Overflown!", 0

section .text
sup_isr_of:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp sup_isr_shared_print_and_hang