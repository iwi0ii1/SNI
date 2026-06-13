bits 64
global ecp_exceptions_default_isr_ac

section .text

align 16
ecp_exceptions_default_isr_ac:

.hang:
    hlt
    jmp .hang