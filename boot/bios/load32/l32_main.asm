%include "disk/disk.inc"
%include "cpu/cpu.inc"
%include "display/display.inc"

%define CFGTB_MAX_CFGS 14
%define CFG_SIZEB      36

%define CFGTB_SECTOR_LOC       2047
%define CFGTB_SECTOR_CNT_4_BIN 1
%define CFGTB_LOAD_DEST        0x1F00

bits 32
global l32_main



l32_config_name              equ 0x00 ; 16 bytes

l32_config_sector_offset     equ 0x10 ; 4 bytes (sector location)
l32_config_bin_size          equ 0x14 ; 4 bytes

l32_config_load_dest         equ 0x18 ; 4 bytes (RAM destination for binary, direct address)
l32_config_entry_offset      equ 0x1C ; 2 bytes (offset starts from bin head)

l32_config_cpu_preset        equ 0x1E ; 4 bytes
l32_config_displayable_modes equ 0x22 ; 1 byte (available display modes)



section .l32_main
l32_main:
    

.hang:
    cli
    hlt
    jmp .hang