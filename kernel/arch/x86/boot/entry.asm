bits 64
global _start
extern init_paging
extern main

section .text
_start:
    ; -----------------------------
    ; 1. Stack setup
    ; -----------------------------
    mov rsp, 0x200000
    and rsp, -16
    sub rsp, 8

    cli
    cld

    ; -----------------------------
    ; 2. Clear general registers
    ; -----------------------------
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    ; -----------------------------
    ; 3. Call init paging and kernel main
    ; -----------------------------
    call init_paging
    call main

.hang:
    hlt
    jmp .hang


section .bss
align 16

;stack_bottom:
;    resb 16384        ; 16 KB stack
;stack_top: