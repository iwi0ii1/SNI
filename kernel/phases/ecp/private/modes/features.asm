bits 64
global ecp_modes_enable_wp

section .text
ecp_modes_enable_wp:
    mov rax, cr0
    or rax, (1 << 16)   ; Flip the Write Protect bit on
    mov cr0, rax

    ret