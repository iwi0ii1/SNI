bits 64
global ecp_interrupts_default_isr_db

section .text

align 16
ecp_interrupts_default_isr_db:

.hang:
    hlt
    jmp .hang