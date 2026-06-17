bits 64
global _start64

section .text
_start64:
    ; 64-bit codes
    mov word [0xB8000], 0xF041
    mov word [0xB8002], 0xF042
    mov word [0xB8004], 0xF043

.hang:
    hlt
    jmp .hang