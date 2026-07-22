; Handoff stage of loader, read boot settings, choose to set the env, and load payload.

%include "bios/macros.inc"

bits 16
org 0x8000

%define LS_HANDOFF_COMMONSTR "Handoff: "

section .ls_handoff
ls_handoff:
; ---------------------------------------------------------
; Handoff rountine (like what the handoff codes would do)
; ---------------------------------------------------------
; ESI -> chosen boot entry begin addr
.handoff_routine:
    movzx bx, byte [LS_MACROS_BOOTCFG_LOAD_DEST_OFF + LS_MACROS_BOOTSETTINGS_FIELD_PRIMARY_OPTION_BEGIN] ; Primary default boot entry option (zero-based)

    ; BX * LS_MACROS_BOOTENTRY_SIZEB + LS_MACROS_BOOTENTRY_SRC_OFF
    imul bx, LS_MACROS_BOOTENTRY_SIZEB
    add bx, LS_MACROS_BOOTENTRY_SRC_OFF

    movzx esi, word [bx] ; BX will always be below 0xFFFF, so it's safe

    ; Load payload according to boot entry
    ; [.dap + 8] is LBA start, which differs at runtime -> defaulted to 0 in DAP
    ; here will set it to the runtime LBA start
    mov eax, dword [si + LS_MACROS_BOOTENTRY_FIELD_START_LBA_BEGIN]
    mov dword [.dap + 8], eax
    ; Halt here for debugging
    cli
    hlt

;--------------------------
; Loop of loading binary
;--------------------------
sectors_count_per_load equ (LS_MACROS_TMP_MEM_END_SEG * 16 + LS_MACROS_TMP_MEM_END_OFF - LS_MACROS_TMP_MEM_BEGIN_OFF + 1) >> 9 ; Doesn't need remainder
.load_loop:
    ; Basically, it will keep loading 600KiB (depends on sectors * 512) from the total binary to
    ; (LS_MACROS_TMP_MEM_END_SEG * 16) + LS_MACROS_TMP_MEM_END_OFF then move the 600KiB to the actual load dest

    xor ax, ax
    mov ds, ax
    mov si, .dap
    mov es, ax ; Just to be sure
    mov ah, 0x42

    int 0x13
    jc .load_failed

    ; ------------------------------
    ; Enters Unreal mode fields
    ; ------------------------------
    call ls_shared_enter_unreal_mode

    ; If remain sectors r less than defined sectors pack count
    mov ax, word [esi + LS_MACROS_BOOTENTRY_FIELD_SECTORS_COUNT_BEGIN]
    cmp ax, sectors_count_per_load
    jb .load_last_sectors

    ; Move bytes to load dest
    push esi
    mov edi, dword [esi + LS_MACROS_BOOTENTRY_FIELD_LOAD_DEST_BEGIN]
    mov esi, LS_MACROS_TMP_MEM_BEGIN_OFF

    mov cx, sectors_count_per_load * 512 / 4
    rep movsd

    pop esi
    add dword [esi + LS_MACROS_BOOTENTRY_FIELD_LOAD_DEST_BEGIN], LS_MACROS_TMP_MEM_END_SEG * 16 + LS_MACROS_TMP_MEM_END_OFF ; Increment load dest
    add dword [.dap + 8], sectors_count_per_load ; Increment LBA begin to next read point
    sub dword [esi + LS_MACROS_BOOTENTRY_FIELD_SECTORS_COUNT_BEGIN], sectors_count_per_load ; Decrement leftover LBA count

    call ls_shared_enter_real_mode

    jmp .load_loop

.load_last_sectors:
    jmp .hang

.jump:


.load_failed:
    xor ax, ax
    mov ds, ax
    mov si, .tell_failed2load_str
    mov ax, 160
    call ls_shared_print_str

.hang:
    cli
    hlt
    jmp .hang

; ----------------------
; Read-only data
; ----------------------
.tell_failed2load_str: db LS_HANDOFF_COMMONSTR, "Failed to load payload.", 0

.dap: ; [.dap+2] and [.dap+8] must be dynamically defined
    db 0x10
    db 0x00
    dw (LS_MACROS_TMP_MEM_END_OFF - LS_MACROS_TMP_MEM_BEGIN_OFF + 1) / 512
    dw LS_MACROS_TMP_MEM_BEGIN_OFF
    dw 0x00
    dq 0x00

%include "bios/shared.inc"
    
times 512 - ($ - $$) db 0 ; Same