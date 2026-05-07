; I made this file to test if it is truly stack problem or corrupted compilation.
bits 64
global kmain



section .rodata
mystr: db "Say wallahi, bro. Say wallahi.", 0
mystr_len equ $ - mystr



section .text
kmain:
    cld

    mov rdi, 0xB8000
    lea rsi, [rel mystr]

    mov ah, 0xF0

.aloop:
    lodsb
    test al, al
    jz .done

    mov ah, 0x0F      ; attribute (white on black)
    stosw             ; write AX to VGA

    jmp .aloop

.done:
    ret