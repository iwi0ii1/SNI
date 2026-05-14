; Jumps to sul_init which will do the setup including enabling long mode, then jumps to _start64 which contains the rest of the layers but in long mode.

bits 32
global _start
extern sul_init

section .text
_start:
    cli
    jmp sul_init