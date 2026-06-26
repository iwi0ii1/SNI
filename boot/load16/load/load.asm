bits 16
global l16_load_from_disk

section .text
l16_load_from_disk:
    ; 1. Setup Disk Address Packet (DAP) on the stack
    ; We need 16 bytes for the DAP structure
    sub sp, 16
    mov bp, sp
    
    mov byte [bp], 0x10         ; DAP Size: 16 bytes
    mov byte [bp+1], 0          ; Reserved
    mov word [bp+2], si         ; Number of sectors
    mov word [bp+4], bx         ; Buffer Offset
    mov word [bp+6], cx         ; Buffer Segment
    mov [bp+8], ax              ; LBA Low
    mov [bp+10], dx             ; LBA High
    mov word [bp+12], 0         ; LBA High-High
    mov word [bp+14], 0         ; LBA High-High
    
    ; 2. Call BIOS INT 13h (Extended Read)
    mov ah, 0x42
    mov dl, 0x80                ; Drive 0x80 (First HDD)
    mov si, bp                  ; DS:SI must point to the DAP
    int 0x13
    
    ; 3. Save CF state before cleaning up the stack
    ; Push flags to stack so we can restore the carry flag later
    pushf
    
    ; Cleanup DAP from stack
    add sp, 16

    jc .error
    
    ret

.error:
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F45