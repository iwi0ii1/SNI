bits 64
global ecp_exceptions_default_isr_bp

section .text

align 16
ecp_exceptions_default_isr_bp:

.hang:
    hlt
    jmp .hang