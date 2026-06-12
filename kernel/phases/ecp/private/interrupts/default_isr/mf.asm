bits 64
global ecp_interrupts_default_isr_mf

section .text

align 16
ecp_interrupts_default_isr_mf:

.hang:
    hlt
    jmp .hang