; Foundation stage of loader, MBR things. Load the next stages.

bits 16
org 0x7C00

ls_foundation: ; Stage 1 (MBR)
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7BFF

    mov [boot_drive], dl

    ; Read 2 sectors to 0000:7E00
    mov bx, 0x7E00
    mov ah, 0x02
    mov al, 2          ; sectors to read
    mov ch, 0          ; cylinder
    mov cl, 2          ; sector (LBA 1)
    mov dh, 0          ; head
    mov dl, [boot_drive]
    int 13h
    jc disk_error

    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0xF041

    jmp 0x0000:0x7E00

.inf:
    hlt
    jmp .inf

disk_error:
    hlt
    jmp disk_error

boot_drive: db 0