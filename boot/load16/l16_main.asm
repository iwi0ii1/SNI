bits 16
global l16_main

section .l16_main
l16_main:
    ; set text mode
    mov ax, 0x0003
    int 10h

    ; 0xB8000 (stos dest ES:DI)
    mov ax, 0xB800
    mov es, ax
    xor di, di

    ; CS + msg (lods src DS:SI)
    mov ax, cs
    mov ds, ax
    mov si, msg

    mov ah, 0x0F

.lup:
    lodsb
    test al, al
    jz .hang

    stosw
    jmp .lup

.hang:
    cli
    hlt
    jmp .hang

msg: db "Hello BIOS from l16_main!", 0