; Default ISR of #PF (Page Fault)
%include "phases/ecp/private/interrupts/default_isr/shared.inc"

bits 64
global ecp_default_isr_pf

section .rodata
error_msg: db "Kernel error: Page fault!", 0

section .text
ecp_default_isr_pf:
    mov rdi, error_msg
    mov sil, 0x0F

    jmp ecp_default_isr_shared_print_and_hang

; Note: Cannot use `call` or anything stack related in ISR,
; don't expect fault to not be related to stack, you don't know.