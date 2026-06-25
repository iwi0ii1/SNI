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
    mov sp, 0x7C00  ; Setup stack safely below the MBR
    sti

    ; Set text mode
    mov ax, 0x0003
    int 10h

    ; LOAD CORE STAGE FROM DISK USING LBA
    mov si, disk_address_packet     ; DS:SI points to our LBA packet
    mov ah, 0x42                    ; BIOS Extended Read function
    ; Note: DL is left untouched because the BIOS naturally loads the boot drive ID into it.
    int 13h                         ; Call BIOS disk read
    jc .disk_error                  ; If the carry flag is set, something failed!

    ; Jump straight to l16_main's execution address
    jmp 0x00:0x7E00

.disk_error:
    ; Flash a red 'E' in the top-left corner if disk read fails
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F45 ; White 'E' on Red background

.hang:
    cli
    hlt
    jmp .hang

; --- BIOS Disk Address Packet (DAP) ---
align 4
disk_address_packet:
    db 0x10                 ; Packet size (Always 16 bytes / 0x10)
    db 0x00                 ; Reserved (Always 0)
    dw 30                   ; Number of sectors to read (Your original 30 sectors / ~15KB)
    dw 0x7E00               ; Destination Offset
    dw 0x0000               ; Destination Segment (0x0000:0x7E00)
    dq 1                    ; Starting LBA block (Sector 1 = immediately following MBR)

; This must be in .load16
times 510 - ($ - $$) db 0  ; Pad this final block
dw 0xAA55                  ; Drop the signature