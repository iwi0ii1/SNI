bits 64
global ecp_exceptions_default_isr_sx

section .text

align 16
ecp_exceptions_default_isr_sx:

.hang:
    hlt
    jmp .hang