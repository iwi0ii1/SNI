bits 64
global ecp_exceptions_default_isr_mc

section .text

align 16
ecp_exceptions_default_isr_mc:

.hang:
    hlt
    jmp .hang