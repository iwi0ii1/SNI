bits 64
global ecp_interrupts_default_isr_nm

section .text

align 16
ecp_interrupts_default_isr_nm:

.hang:
    hlt
    jmp .hang