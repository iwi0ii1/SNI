bits 16
org 0x7C00

global l16_mbr

l16_mbr:
    ; Clear interrupts and setup segments cleanly
    cli
    cld

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1000 ; 0x00 - 0x04FF is used by BIOS, 0x500+ are safe. Stack range: 0x500 - 0x1000
    sti

    ; Set text mode
    mov ax, 0x0003
    int 0x10

    ; Load core stage from disk using LBA
    mov si, disk_address_packet ; DS:SI points to DAP
    mov ah, 0x42                ; BIOS Extended Read function
    int 0x13                    ; Call BIOS disk read
    jc .disk_error              ; BIOS set CF for failure

    jmp 0x00:0x7E00 ; Far jump to l16_main (changes CS:IP)

.disk_error:
    ; Red 'E' as indicator
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F45

.hang:
    cli
    hlt
    jmp .hang

; --- BIOS Disk Address Packet (DAP) ---
align 4
disk_address_packet:
    db 0x10   ; Packet size = 16 bytes
    db 0x00   ; Reserved (mandatory)
    dw 30     ; Number of sectors to read (15KiB)
    dw 0x7E00 ; Load destination offset (0x00:0x7E00)
    dw 0x00   ; Load destination segment (0x00:0x7E00)
    dq 1      ; Sector to begin (0-based)

; BIOS signature
times 510 - ($ - $$) db 0  ; Pad with 0s.
dw 0xAA55