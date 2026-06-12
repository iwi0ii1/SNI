bits 64
global ecp_interrupts_default_isr_br

section .text

align 16
ecp_interrupts_default_isr_br:

.hang:
    hlt
    jmp .hang