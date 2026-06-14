%include "phases/ecp/private/exposed.inc"

bits 64
global _start64

extern hip_init
extern rtp_init

section .bss
align 16
stack_bottom:
resb 1024 * 32 ; 32KiB
stack_top:

section .text
_start64:
    cld
    cli

    mov rsp, stack_top
    sub rsp, 8
    and rsp, -16 ; Align by 16

    call ecp_modes_init
    call ecp_memory_init
    call ecp_segments_init
    call ecp_exceptions_init

    mov word [0xB8000], 0xF041
    hlt

    call hip_init
    call rtp_init

    sti

    ; Spawn init here or call smth that spawns it

    cli

.hang:
    hlt
    jmp .hang