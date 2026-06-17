bits 64
global _start64

section .text
_start64:
    ; 64-bit codes

.hang:
    hlt
    jmp .hang