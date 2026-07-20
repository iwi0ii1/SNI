; Just shared functions that can be used by anyone else... only include this at the bottom of the code, never at the top as being at the top might lead to unintentional jmp to the functions below.
%ifndef LS_SHARED_INC
%define LS_SHARED_INC

bits 16

%ifndef LS_SHARED_EXCLUDE_PRINT_STR
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
%endif



%ifndef LS_SHARED_EXCLUDE_ENTER_MODES
; Just enter unreal mode, BIOS interrupts might make things bad,
; so make sure to return to real mode before BISO interrupts.
ls_shared_enter_unreal_mode:
    cli

    lgdt [ls_shared_unreal_mode_gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:.hi_protected_mode

bits 32
.hi_protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov eax, cr0
    and eax, 0xFFFFFFFE
    mov cr0, eax

bits 16
    jmp 0x00:.back_to_real_mode

.back_to_real_mode:
    sti

    ret



; Technically unreal mode IS real mode... but to make it normal real mode, this is the one.
ls_shared_enter_real_mode:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ret
    


ls_shared_unreal_mode_gdt:
.null:
    dq 0
.code:
    ; base=0, limit=4GB, code segment
    dw 0xffff
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0
.data:
    ; base=0, limit=4GB, data segment
    dw 0xffff
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
.end:

ls_shared_unreal_mode_gdt_descriptor:
    dw ls_shared_unreal_mode_gdt.end - ls_shared_unreal_mode_gdt - 1
    dd ls_shared_unreal_mode_gdt

%endif
%endif