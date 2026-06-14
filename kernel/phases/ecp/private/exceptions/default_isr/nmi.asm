bits 64
global ecp_exceptions_default_isr_nmi

section .text

align 16
ecp_exceptions_default_isr_nmi:

.hang:
    hlt
    jmp .hang