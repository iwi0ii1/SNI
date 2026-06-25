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

    ; LOAD CORE STAGE FROM DISK
    mov ah, 0x02    ; BIOS read sectors function
    mov al, 30      ; Read exactly 30 sectors (approx 15KB of code space)
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Sector 2 (Sector 1 is this MBR, Sector 2 is l16_main)
    mov dh, 0       ; Head 0

    ; Load to 0x00:0x7E00 (ES:BS)
    xor ax, ax
    mov es, ax
    mov bx, 0x7E00  
    int 13h         ; Call BIOS disk read
    jc .disk_error  ; If the carry flag is set, something failed!

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

; This must be in .load16
times 510 - ($ - $$) db 0  ; Pad this final block
dw 0xAA55                  ; Drop the signature