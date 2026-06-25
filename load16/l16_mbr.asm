bits 16
global l16_mbr

section .l16_mbr
l16_mbr:
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

; This must be in .load16
times 510 - ($ - $$) db 0  ; Pad this final block
dw 0xAA55                  ; Drop the signature