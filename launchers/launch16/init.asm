bits 16
global launch16

section .text.launch16
launch16:
    ; Set vid mode to 640x480@1
    xor ah, ah
    mov al, 0x11
    int 0x10
    
    ; For 0xA0000 (ES:DI == ES*16 + DI)
    mov ax, 0xA000
    mov es, ax
    xor di, di

    mov ax, 0b1010_1010_1010_1010

.lup:
    ; For a row
    mov cx, 40
    rep stosw

    ; Check one past end
    cmp di, 0x9600
    jz .hang

    not ax ; Flip it

    jmp .lup

.hang:
    cli
    hlt
    jmp .hang

times 510 - ($ - $$) db 0
dw 0xAA55