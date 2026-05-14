; Where everything starts, but _start only jumps to sul_init which will do the setup including enabling long mode and jump to _start64.

bits 32
global _start
extern sul_init

section .text
_start:
    cli
    jmp sul_init