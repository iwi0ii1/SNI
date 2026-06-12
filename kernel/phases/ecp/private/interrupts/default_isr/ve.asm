bits 64
global ecp_interrupts_default_isr_ve

section .text

align 16
ecp_interrupts_default_isr_ve:

.hang:
    hlt
    jmp .hang