bits 64
global ecp_interrupts_default_isr_bp

section .text

align 16
ecp_interrupts_default_isr_bp:

.hang:
    hlt
    jmp .hang