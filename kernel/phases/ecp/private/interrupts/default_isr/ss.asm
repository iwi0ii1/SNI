bits 64
global ecp_interrupts_default_isr_ss

section .text

align 16
ecp_interrupts_default_isr_ss:

.hang:
    hlt
    jmp .hang