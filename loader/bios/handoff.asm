; Handoff stage of loader, read boot settings, choose to set the env, and load payload.

%include "bios/macros.inc"

%define LS_HANDOFF_COMMONSTR "> Loader handoff stage: "

bits 16
org 0x8000

section .ls_handoff
ls_handoff:
    ; Primary default boot entry option
    mov al, [LS_MACROS_BOOTCFG_LOAD_DEST_OFF + LS_MACROS_BOOTSETTINGS_FIELD_PRIMARY_OPTION_BEGIN]
    test al, al
    jnz .actual_handoff

    ; Prompt user for boot entry option
    ; ...
    jmp .load_failed

.actual_handoff: ; AL -> boot entry option
    ; DS:SI -> chosen boot entry begin addr
    movzx bx, al

    ; BX * LS_MACROS_BOOTENTRY_SIZEB + LS_MACROS_BOOTENTRY_SRC_OFF
    ; Explicit opimization
    %if LS_MACROS_BOOTENTRY_SIZEB == 34
    
    %else
    imul bx, LS_MACROS_BOOTENTRY_SIZEB
    %endif
    add bx, LS_MACROS_BOOTENTRY_SRC_OFF

    mov si, word [bx] ; AX illegal here in real mode
    xor ax, ax
    mov ds, ax


    ; Load payload
    mov cx, word [ds:si + LS_MACROS_BOOTENTRY_FIELD_LBA_COUNT_BEGIN]
    mov es, ax ; AX already 0
    mov bx, word [ds:si + LS_MACROS_BOOTENTRY_FIELD_LOAD_DEST_BEGIN]
    mov eax, dword [ds:si + LS_MACROS_BOOTENTRY_FIELD_LBA_SRC_BEGIN]

    call ls_shared_load_from_disk
    jc .load_failed ; FIXME Still reachable

.load_failed:
    xor ax, ax
    mov ds, ax
    mov si, .tell_failed2load_str
    mov ax, 160
    call ls_shared_print_str

.hang:
    hlt
    jmp .hang

.tell_failed2load_str: db LS_HANDOFF_COMMONSTR, "failed to load.", 0

%include "bios/shared.inc"
    
times 512 - ($ - $$) db 0 ; Same