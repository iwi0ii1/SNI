bits 64
global ecp_exceptions_default_isr_de

section .text

align 16
ecp_exceptions_default_isr_de:

.hang:
    hlt
    jmp .hang