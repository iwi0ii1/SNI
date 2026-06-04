; ISR of #PF (Page Fault)
%include "phases/sup/private/isr/shared.inc"

bits 64
global sup_isr_pf

section .rodata
error_msg: db "Kernel error: Page fault!", 0

section .text
sup_isr_pf:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp sup_isr_shared_print_and_hang

; Note: Cannot use `call` or anything stack related in ISR,
; don't expect fault to not be related to stack, you don't know.