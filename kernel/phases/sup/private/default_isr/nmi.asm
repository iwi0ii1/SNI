; Default ISR of Non-Maskable Interrupt (NMI)
; This default ISR is special as it cannot be cancelled and usually means smth very bad happened at hardware level.
%include "phases/sup/private/default_isr/shared.inc"

bits 64
global sup_default_isr_nmi

section .rodata
fatal_msg: db "Kernel fatal: NMI reached!", 0

section .text
sup_default_isr_nmi:
    mov rdi, fatal_msg
    mov sil, 0x0F

    jmp sup_default_isr_shared_print_and_hang