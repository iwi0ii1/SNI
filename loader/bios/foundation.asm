; Foundation stage of loader, MBR things. Load the next stages.

%include "bios/macros.inc"

%define LS_FOUNDATION_LOAD_BY_LBA 1

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
    ; Read sector 1 and 2, load to 0x7E00 - 0x8200
    ; ES:BX = load dest

    %if LS_FOUNDATION_LOAD_BY_LBA == 1
    ; LBA-based loading
    mov ax, LS_MACROS_NEXT_STAGES_LOAD_DEST_OFF
    mov es, ax
    xor bx, bx

    mov si, dap
    mov ah, 0x42

    %else
    ; CHS-based loading
    mov bx, 0x7E00
    mov ah, 0x02
    mov al, LS_MACROS_NEXT_STAGES_SECTOR_COUNT ; sectors to read
    xor ch, ch ; cylinder
    xor dh, dh ; head
    mov cl, 2  ; sector (LBA 1)

    %endif

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

.tell_done_str: db "> Loader foundation stage: done.", 0

disk_error:
    hlt
    jmp disk_error

%if LS_FOUNDATION_LOAD_BY_LBA == 1
dap:
    db 0x10                                ; DAP size
    db 0x00                                ; Reserved
    dw LS_MACROS_NEXT_STAGES_SECTOR_COUNT  ; Sectors to read
    dw LS_MACROS_NEXT_STAGES_LOAD_DEST_OFF ; Load dest offset
    dw 0x00                                ; Load dest segment
    dq 0x01                                ; LBA sector (starts at 0)
%endif

times 510 - ($ - $$) db 0 ; BIOS signature and 512 byte alignment
dw 0xAA55