; Just shared functions that can be used by anyone else... only include this at the bottom of the code, never at the top as being at the top might lead to unintentional jmp to the functions below.
%ifndef LS_SHARED_INC
%define LS_SHARED_INC

bits 16

; DS:SI -> str source, AX -> begin slot, note: must be null-terminated
ls_shared_print_str:
    shl ax, 1 ; AX * 2, rescale BYTE to WORD
    mov di, ax

    cmp di, 2000
    jae .done

    mov ax, 0xB800
    mov es, ax

.lup:
    mov ah, 0xF0 ; Forced color attribute: Black fg White bg
    lodsb ; Load current char from DS:SI to AL

    test al, al
    jz .done
    
    stosw ; Store AX to ES:DI
    jmp .lup

.done:
    ret



; EAX -> LBA Src Begin (starts at 0), CX -> LBA Count -> LBA ES:BX -> Load Dest
; CF set -> failed.
ls_shared_load_from_disk:
    mov dword [.dap_lba_begin], eax ; i386 already supports this in real mode natively
    mov word [.dap_lba_count], cx
    mov word [.dap_load_dest_seg], es
    mov word [.dap_load_dest_off], bx

    xor ax, ax
    mov ds, ax
    mov si, .dap_size_and_reserved
    mov ah, 0x42

    int 0x13

    ret

.dap_size_and_reserved:
    db 0x10 ; DAP size
    db 0x00 ; reserved
.dap_lba_count:     dw 0x00 ; sectors to read
.dap_load_dest_off: dw 0x00 ; buffer offset
.dap_load_dest_seg: dw 0    ; buffer segment
.dap_lba_begin:     dq 0x00 ; LBA sector start

%endif