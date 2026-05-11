; I made this file to test if it is truly stack problem or corrupted compilation.
bits 64
global kmain

section .rodata
mystr: db "Say wallahi, bro. Say wallahi.", 0

section .text
kmain:
    cld

    mov rdi, 0xB8000
    mov rsi, mystr
    mov ah, 0xF0

    jmp .aloop
    ret

.aloop:
    mov al, [rsi]
    mov word [rdi], ax

    add rdi, 2
    inc rsi

    cmp byte [rsi], 0x0
    jnz .aloop