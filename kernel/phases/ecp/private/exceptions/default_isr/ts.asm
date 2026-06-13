bits 64
global ecp_exceptions_default_isr_ts

section .text

align 16
ecp_exceptions_default_isr_ts:

.hang:
    hlt
    jmp .hang