bits 64
global ecp_modes_enable_mmx
global ecp_modes_enable_sse
global ecp_modes_enable_avx

section .text
ecp_modes_enable_mmx:
    mov rax, cr0
    and ax, 0xFFFB              ; Clear CR0.EM (Bit 2) -> Do not emulate coprocessor
    or ax, 0x0002               ; Set CR0.MP (Bit 1)   -> Monitor coprocessor
    mov cr0, rax

    ret



ecp_modes_enable_sse:
    ; Configure CR0 for Coprocessor/SIMD execution
    mov rax, cr0
    and ax, 0xFFFB              ; Clear CR0.EM (Disable Emulation so it uses real silicon)
    or ax, 0x0002               ; Set CR0.MP (Monitor Coprocessor)
    mov cr0, rax

    ; Configure CR4 to enable SSE instructions and exception handling
    mov rax, cr4
    or ax, (3 << 9)             ; Set Bit 9 (OSFXSR) and Bit 10 (OSXMMEXCPT)
    mov cr4, rax

    ret



ecp_modes_enable_avx:
    ; Uncap OSXSAVE so we can modify the Extended Control Register (XCR0)
    mov rax, cr4
    or eax, (1 << 18)           ; Set CR4.OSXSAVE (Bit 18)
    mov cr4, rax

    ; Configure XCR0 to enable AVX, SSE, and x87 states concurrently
    xor ecx, ecx                ; Specify XCR0 index 0
    xgetbv                      ; Read current XCR0 state into EDX:EAX
    or eax, 7                   ; Toggle Bit 0 (x87), Bit 1 (SSE), and Bit 2 (AVX)
    xsetbv                      ; Commit back to the CPU execution engine

    ret