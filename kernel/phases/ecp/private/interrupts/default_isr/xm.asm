bits 64
global ecp_interrupts_default_isr_xm

section .text

align 16
ecp_interrupts_default_isr_xm:

.hang:
    hlt
    jmp .hang