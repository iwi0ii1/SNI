; ISR of #DE (Divide Error)
%include "phases/sup/private/isr/shared.inc"

bits 64
global sup_isr_de

section .rodata
error_msg: db "Kernel error: Divided by zero!", 0

section .text
sup_isr_de:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp sup_isr_shared_print_and_hang