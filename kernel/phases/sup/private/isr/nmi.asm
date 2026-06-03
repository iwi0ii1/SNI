; ISR of Non-Maskable Interrupt (NMI)
; This ISR is special as it cannot be cancelled and usually means smth very bad happened at hardware level.
%include "shared/vgatb.inc"

bits 64
global sup_isr_nmi

section .rodata
fatal_msg: db "Kernel fatal: NMI reached!", 0

section .text
sup_isr_nmi:
    cli

    push rax
    push rdi
    push rsi

    mov rdi, fatal_msg
    mov sil, 0x0F
    call shared_vgatb_aputs

.done:
    pop rsi
    pop rdi
    pop rax

.hang:
    hlt
    jmp .hang