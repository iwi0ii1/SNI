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
    lodsb           ; AL = [RSI], RSI++
    test al, al
    jz .done

    movzx rbx, al     ; expand safely
    mov ax, bx        ; AX = 0x00?? (we fix next line)
    mov al, bl
    mov ah, 0x0F      ; reassert color (important)

    stosw
    jmp .aloop

.done:
    ret