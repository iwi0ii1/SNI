bits 64
global ecp_interrupts_default_isr_nmi

section .text

align 16
ecp_interrupts_default_isr_nmi:

.hang:
    hlt
    jmp .hang