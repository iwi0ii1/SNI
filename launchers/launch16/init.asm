bits 16
global launch16

section .text.launch16
launch16:
    ; set text mode
    mov ax, 0003h
    int 10h

    ; ES = video memory
    mov ax, 0B800h
    mov es, ax
    xor di, di

    ; DS = boot segment (7C00h)
    mov ax, 07C0h
    mov ds, ax

    mov si, msg

    mov al, [si]

    mov ah, 0x0F

    stosw

    hlt

.lup:
    lodsb           ; AL = [DS:SI]
    test al, al
    jz .hang

    stosw           ; write AX = (char + attribute)
    jmp .lup

.hang:
    cli
    hlt
    jmp .hang

msg: db "Hello BIOS!", 0

times 510 - ($ - $$) db 0
dw 0xAA55