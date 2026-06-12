bits 64
global ecp_interrupts_default_isr_mc

section .text

align 16
ecp_interrupts_default_isr_mc:

.hang:
    hlt
    jmp .hang