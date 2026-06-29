%define L32_SHARED_BIOSCALL_CALL_FRAME_LOC 0x2000

%define L32_SHARED_BIOSCALL_INT_NUM_OFF 0
%define L32_SHARED_BIOSCALL_AX_OFF 1
%define L32_SHARED_BIOSCALL_BX_OFF 3
%define L32_SHARED_BIOSCALL_CX_OFF 5
%define L32_SHARED_BIOSCALL_DX_OFF 7
%define L32_SHARED_BIOSCALL_SI_OFF 9
%define L32_SHARED_BIOSCALL_DI_OFF 11
%define L32_SHARED_BIOSCALL_BP_OFF 13
%define L32_SHARED_BIOSCALL_ES_OFF 15
%define L32_SHARED_BIOSCALL_DS_OFF 17

bits 32
global l32_bios_call

section .text
l32_bios_call:
    pushad
    pushfd

    cli

    ; Enter real mode
    mov eax, cr0
    and eax, 0xFFFFFFFE
    mov cr0, eax

    jmp 0x0000:real_mode_entry

pm_entry:
    mov ax, 0x10 ; Flat data selector defined in MBR
    mov ds, ax
    mov es, ax
    mov ss, ax

    popfd
    popad
    ret



bits 16
real_mode_entry:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Load registers from frame
    ; AX will be loaded later
    mov bx, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_BX_OFF]
    mov cx, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_CX_OFF]
    mov dx, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_DX_OFF]
    mov si, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_SI_OFF]
    mov di, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_DI_OFF]
    mov bp, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_BP_OFF]

    mov ax, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_DS_OFF]
    mov ds, ax

    mov ax, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_ES_OFF]
    mov es, ax

    mov al, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_INT_NUM_OFF]
    mov byte [bios_int + 1], al ; Rewrite INT number (CD 0x0 -> CD 0xn)

    mov ax, [L32_SHARED_BIOSCALL_CALL_FRAME_LOC + L32_SHARED_BIOSCALL_AX_OFF] ; Finally load AX

    sti
    
bios_int:
    int 0x00
    cli

    ; Return to protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:pm_entry ; Flat code selector already set in MBR