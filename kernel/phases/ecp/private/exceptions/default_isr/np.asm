bits 64
global ecp_exceptions_default_isr_np

section .text

align 16
ecp_exceptions_default_isr_np:

.hang:
    hlt
    jmp .hang