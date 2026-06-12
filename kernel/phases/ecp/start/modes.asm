; Set dynamic modes of CPU
bits 64

global ecp_modes_enable_mmx
global ecp_modes_enable_sse
global ecp_modes_enable_syscall

section .text
ecp_modes_enable_sse:
    ; --- Configure CR4 ---
    mov rax, cr4
    or rax, (1 << 9)    ; Set OSFXSR (Bit 9)
    or rax, (1 << 10)   ; Set OSXMMEXCPT (Bit 10)
    mov cr4, rax

    ; --- Configure CR0 ---
    mov rax, cr0
    and rax, ~(1 << 2)  ; Clear EM (Bit 2) - Disables emulation
    or rax, (1 << 1)    ; Set MP (Bit 1)   - Monitors coprocessor
    mov cr0, rax

    ret

ecp_modes_enable_mmx:
    ; Ensure emulation is off and math monitoring is on
    mov rax, cr0
    and rax, ~(1 << 2)  ; Clear EM (Bit 2)
    or rax, (1 << 1)    ; Set MP (Bit 1)
    mov cr0, rax
    
    finit               ; Initialize the x87 FPU / MMX state hardware
    ret

ecp_modes_enable_syscall:
    mov ecx, 0xC0000080 ; EFER MSR constant address
    rdmsr               ; Read EFER into EDX:EAX
    or eax, (1 << 0)    ; Set SCE (Bit 0) - System Call Extension enable bit
    wrmsr               ; Write it back to the CPU

    ret