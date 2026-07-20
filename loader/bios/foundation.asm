; Foundation stage of loader, MBR things. Load the next stages.

%include "bios/macros.inc"

bits 16
org 0x7C00 ; Foundation is MBR, bruh

section .ls_foundation
ls_foundation: ; MBR
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Enable A20
    in al, 0x92
    test al, 2
    jnz .skip

    or al, 2
    and al, 0xFE ; avoid triggering reset
    out 0x92, al

.skip:
    ; Load the next stages
    mov si, .dap
    mov ah, 0x42

    int 0x13
    jc .hang

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

    jmp 0x0000:LS_MACROS_NEXT_STAGES_LOAD_DEST_OFF

.hang:
    cli
    hlt
    jmp .hang

.tell_done_str: db "Foundation: Done.", 0

.dap:
    db 0x10                                ; DAP size
    db 0x00                                ; Reserved
    dw LS_MACROS_NEXT_STAGES_LBA_COUNT     ; Sectors to read
    dw LS_MACROS_NEXT_STAGES_LOAD_DEST_OFF ; Load dest offset
    dw 0x00                                ; Load dest segment
    dq LS_MACROS_NEXT_STAGES_LBA_BEGIN     ; LBA begin (starts with 0)

times 510 - ($ - $$) db 0 ; BIOS signature and 512 byte alignment
dw 0xAA55