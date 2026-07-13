%ifndef LS_MACROS_INC
%define LS_MACROS_INC

bits 16

; Stages
%define LS_MACROS_NEXT_STAGES_SECTOR_COUNT 3
%define LS_MACROS_NEXT_STAGES_LOAD_DEST_OFF 0x7E00

; Collected infos
%define LS_MACROS_E820_LOAD_DEST_OFF 0x9000
%define LS_MACROS_VBE_CTRL_INFO_DEST_OFF 0x9C00

; Boot configuration (entries + settings range, not individual domain)
%define LS_MACROS_BOOTCFG_LBA_START 4
%define LS_MACROS_BOOTCFG_SECTOR_COUNT 1
%define LS_MACROS_BOOTCFG_LOAD_DEST_OFF 0x8200

; Boot entry/entries
%define LS_MACROS_BOOTENTRY_COUNT 17
%define LS_MACROS_BOOTENTRY_SIZEB 30
; Boot settings
%define LS_MACROS_BOOTSETTINGS_SIZEB 2

%endif