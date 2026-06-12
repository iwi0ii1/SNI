bits 64
global ecp_interrupts_default_isr_ud

section .text

align 16
ecp_interrupts_default_isr_ud:

.hang:
    hlt
    jmp .hang