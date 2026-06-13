bits 64
global ecp_exceptions_default_isr_ss

section .text

align 16
ecp_exceptions_default_isr_ss:

.hang:
    hlt
    jmp .hang