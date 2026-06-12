bits 64
global ecp_interrupts_default_isr_ac

section .text

align 16
ecp_interrupts_default_isr_ac:

.hang:
    hlt
    jmp .hang