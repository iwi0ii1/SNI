; I made this file to test if it is truly stack problem or corrupted compilation.
bits 64
section .rodata
mystr: db "Say wallahi, bro. Say wallahi.", 0
mystr_len equ $ - mystr

section .text
kmain:
    