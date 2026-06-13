bits 64
global ecp_exceptions_default_isr_nm

section .text

align 16
ecp_exceptions_default_isr_nm:

.hang:
    hlt
    jmp .hang