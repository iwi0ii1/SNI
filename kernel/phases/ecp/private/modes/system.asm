bits 64
global ecp_modes_enable_syscall

section .text
ecp_modes_enable_syscall:
    mov ecx, 0xC0000080         ; Target the Extended Feature Enable Register (EFER MSR)
    rdmsr
    or eax, (1 << 0)            ; Flip the System Call Enable (SCE) bit on
    wrmsr

    ret