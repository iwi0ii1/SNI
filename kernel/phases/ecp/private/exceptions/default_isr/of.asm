bits 64
global ecp_exceptions_default_isr_of

section .text

align 16
ecp_exceptions_default_isr_of:

.hang:
    hlt
    jmp .hang