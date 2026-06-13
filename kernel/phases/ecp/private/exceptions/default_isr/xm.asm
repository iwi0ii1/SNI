bits 64
global ecp_exceptions_default_isr_xm

section .text

align 16
ecp_exceptions_default_isr_xm:

.hang:
    hlt
    jmp .hang