; ISR of #PF (Page Fault)
%include "shared/vgatb.inc"

bits 64
global sup_isr_pf

section .rodata
error_msg: db "Kernel error: Page fault!", 0

section .text
sup_isr_pf:
    cli

    push rax
    push rdi
    push rsi

    mov rdi, error_msg
    mov sil, 0x0F
    call shared_vgatb_aputs

.done:
    pop rsi
    pop rdi
    pop rax

.hang:
    hlt
    jmp .hang

; Note: Cannot use `call` or anything stack related in ISR,
; don't expect fault to not be related to stack, you don't know.