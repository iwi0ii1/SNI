; MBR at sector 0 and sector 1 (extended), prepares Long mode transition -> check signature (0xABABCDCD - 0x54543232)

%define SIGNATURE_START 0xABABCDCD
%define SIGNATURE_END   0x54543232
%define SIGNATURE_LOAD_DEST_OFF 0x1000

bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    sti
    
    mov byte [boot_disk], dl ; Save boot disk source

    ; Enable A20 (so it doesn't wrap)
    in al, 0x92
    or al, 2
    out 0x92, al

.find_start_signature:
    mov si, dap
    mov ah, 0x42

    int 0x13
    jc disk_error

.find_end_signature:
    ; Find 0x

.start_continue:
    mov dl, [boot_drive]


dap:
    db 16     ; Size of DAP (always 16 anyway)
    db 0      ; Reserved
    dw 1      ; Sectors to read
    dw SIGNATURE_LOAD_DEST_OFF ; Load dest offset
    dw 0x00   ; Load dest segment
    dq 2048   ; Sector location

disk_error:
    hlt
    jmp disk_error

boot_disk: db 0 ; BIOS passed DL (boot disk source)

times 510-($-$$) db 0
dw 0xAA55