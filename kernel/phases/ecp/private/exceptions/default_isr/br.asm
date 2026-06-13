bits 64
global ecp_exceptions_default_isr_br

section .text

align 16
ecp_exceptions_default_isr_br:

.hang:
    hlt
    jmp .hang