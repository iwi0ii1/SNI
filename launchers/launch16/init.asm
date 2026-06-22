bits 16
global launch16

section .text.launch16
launch16:
    ; set text mode
    mov ax, 0003h
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

    lodsb
    stosw
    hlt

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

msg: db "Hello BIOS!", 0

times 510 - ($ - $$) db 0
dw 0xAA55