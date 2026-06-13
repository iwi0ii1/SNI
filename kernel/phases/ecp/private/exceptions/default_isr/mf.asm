bits 64
global ecp_exceptions_default_isr_mf

section .text

align 16
ecp_exceptions_default_isr_mf:

.hang:
    hlt
    jmp .hang