; Just shared functions that can be used by anyone else... only include this at the bottom of the code, never at the top as being at the top might lead to unintentional jmp to the functions below.
%ifndef LS_SHARED_INC
%define LS_SHARED_INC

bits 16

; DS:SI str source, AX begin slot, note: must be null-terminated
print_str:
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

%endif