bits 16
org 0x7C00

global l16_mbr

; In your data section
gdt_start:
    dq 0 ; Null descriptor
gdt_code:
    dw 0xFFFF    ; Limit 0-15
    dw 0x0000    ; Base 0-15
    db 0x00      ; Base 16-23
    db 10011010b ; Access (Code, Exec/Read)
    db 11001111b ; Granularity (4K, 32-bit)
    db 0x00      ; Base 24-31
gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b ; Access (Data, Read/Write)
    db 11001111b
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

l16_mbr:
    ; Clear interrupts and setup segments cleanly
    cli
    cld

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x1000 ; 0x00 - 0x04FF is used by BIOS, 0x500+ are safe. Stack range: 0x500 - 0x1000

    ; Enable A20 gate
    in al, 0x92
    or al, 2
    out 0x92, al

    sti

    ; Set text mode
    mov ax, 0x0003
    int 0x10

    ; Load core stage from disk using LBA
    mov si, disk_address_packet ; DS:SI points to DAP
    mov ah, 0x42                ; BIOS Extended Read function
    int 0x13                    ; Call BIOS disk read
    jc .disk_error              ; BIOS set CF for failure

    cli               ; Disable interrupts
    lgdt [cs:gdt_descriptor]

    mov eax, cr0
    or eax, 1         ; Set PE (Protection Enable) bit
    mov cr0, eax

    ; Far jump to reload CS and enter 32-bit mode
    ; Assuming your code segment is the first descriptor after the null
    jmp 0x08:.protected_mode

.disk_error:
    ; Red 'E' as indicator
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F45

.hang:
    cli
    hlt
    jmp .hang

bits 32
.protected_mode:
    ; Setup segment registers for the data segment
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000

    jmp 0x7E00 ; Jump to l32_main

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