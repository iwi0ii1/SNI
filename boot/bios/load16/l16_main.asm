%include "load/load.inc"
%include "cpu/cpu.inc"
%include "display/display.inc"

%define CFGTB_MAX_CFGS 14
%define CFG_SIZEB      36

%define CFGTB_SECTOR_LOC       2047
%define CFGTB_SECTOR_CNT_4_BIN 1
%define CFGTB_LOAD_DEST        0x1F00

bits 16
global l16_main



l16_config_name              equ 0x00 ; 16 bytes

l16_config_sector_offset     equ 0x10 ; 4 bytes (sector location)
l16_config_bin_size          equ 0x14 ; 4 bytes

l16_config_load_dest         equ 0x18 ; 4 bytes (RAM destination for binary, direct address)
l16_config_entry_offset      equ 0x1C ; 2 bytes (offset starts from bin head)

l16_config_cpu_preset        equ 0x1E ; 4 bytes
l16_config_displayable_modes equ 0x22 ; 1 byte (available display modes)



section .l16_main
l16_main:
    ; Set text mode
    mov ax, 0x0003
    int 0x10

    ; Load 0x200 - 0x3FF (config table, 36 bytes each, last 8 bytes for extra infos, cfg before 0x3F8)
    mov edi, CFGTB_SECTOR_LOC
    mov si, CFGTB_SECTOR_CNT_4_BIN
    mov edx, CFGTB_LOAD_DEST
    call l16_load_from_disk

    ; Load a selection
    mov al, byte [CFGTB_LOAD_DEST + CFG_SIZEB * CFGTB_MAX_CFGS] ; Default selection

    test al, al
    jz .dflt_0

    cmp al, CFGTB_MAX_CFGS
    ja .invld_idx

    sub al, 1
    ; AL *= 36
    xor ah, ah
    mov cx, ax
    shl ax, 5 ; AX *= 32
    shl cx, 2 ; CX *= 4
    add ax, cx
    mov cx, CFGTB_LOAD_DEST
    add cx, ax ; CX = Default selection start cfg addr
    
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0xF068
    mov word [es:2], 0xF069

    jmp .hang
    
.hang:
    cli
    hlt
    jmp .hang

.invld_idx:
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F49
    jmp .hang

.dflt_0:
    ; Doesn't have selection prompting so far.
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F42
    jmp .hang