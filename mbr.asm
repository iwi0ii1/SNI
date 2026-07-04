; MBR at sector 0 and sector 1 (extended), prepares Long mode transition -> check signature (0xABABCDCD - 0x54543232)

bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    sti

    mov si, 2048              ; LBA start
    mov [first_found], byte 0

.next_sector:
    call read_sector_0x1000

    mov di, 0x1000
    mov cx, 512/4             ; 128 dwords

.scan_loop:
    mov eax, [di]

    cmp byte [first_found], 0
    jne search_second

    cmp eax, 0xABABCDCD
    je mark_first

    jmp continue_scan

mark_first:
    mov byte [first_found], 1

continue_scan:
    add di, 4
    loop scan_loop

    inc si
    jmp next_sector

; ----------------------------

search_second:
    cmp eax, 0x54543232
    je found_both

    add di, 4
    loop scan_loop

    inc si
    jmp next_sector

; ----------------------------

found_both:
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0xF059
    hlt
    jmp found_both

; ----------------------------

read_sector_0x1000:
    pusha

    mov ah, 0x42              ; LBA read (INT 13h extensions)
    mov dl, [boot_drive]

    mov si, dap               ; Disk Address Packet
    int 0x13

    popa
    ret

; ----------------------------

first_found: db 0
boot_drive: db 0

; Disk Address Packet (DAP)
dap:
    db 0x10        ; size
    db 0x00        ; reserved
    dw 1           ; sectors to read
    dw 0x1000      ; offset
    dw 0x0000      ; segment
    dq 2048        ; LBA

times 510-($-$$) db 0
dw 0xAA55