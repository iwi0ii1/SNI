bits 64
global ecp_exceptions_default_isr_db

section .text

align 16
ecp_exceptions_default_isr_db:

.hang:
    hlt
    jmp .hang