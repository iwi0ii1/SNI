bits 64
global ecp_exceptions_default_isr_ud

section .text

align 16
ecp_exceptions_default_isr_ud:

.hang:
    hlt
    jmp .hang