; Foundation stage of loader, MBR things. Load the next stages.

bits 16
org 0x7C00 ; Foundation is MBR, bruh

section .ls_foundation
ls_foundation: ; Stage 1 (MBR)
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Enable A20

    ; Read 2 sectors to 0000:7E00
    mov bx, 0x7E00
    mov ah, 0x02
    mov al, 2  ; sectors to read
    xor ch, ch ; cylinder
    xor dh, dh ; head
    mov cl, 2  ; sector (LBA 1)
    int 0x13
    jc disk_error

    ; Clear screen
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ax, 0xF000

    mov cx, 2000
    rep stosw

    ; Prep for msg
    mov ax, 0xB800 ; At first line
    mov es, ax
    xor di, di
    mov ax, 0xF000

    mov si, .tell_done_str ; This is safe as long as `tell_done_str` doesn't pass (0x7DFE - strlen) in memory

.done:
    ; Tell that loader's foundation has been done
    mov al, byte [si]
    stosw
    inc si

    test al, al
    jnz .done

    jmp 0x0000:0x7E00

.tell_done_str: db "SNI's loader's foundation stage has successfully done its job.", 0

disk_error:
    hlt
    jmp disk_error