%include "load/load.inc"
%include "cpu/cpu.inc"
%include "display/display.inc"

bits 16
global l16_main



l16_config_name              equ 0x00 ; 16 bytes

l16_config_disk_offset       equ 0x10 ; 4 bytes (disk location of binary, direct address)
l16_config_bin_size          equ 0x14 ; 4 bytes

l16_config_load_dest         equ 0x18 ; 4 bytes (RAM destination for binary, direct address)
l16_config_entry_offset      equ 0x1C ; 2 bytes (offset starts from bin head)

l16_config_cpu_preset        equ 0x1E ; 4 bytes
l16_config_displayable_modes equ 0x22 ; 1 byte (available display modes)



section .l16_main
l16_main:
    ; Set text mode
    mov ax, 0x0003
    int 10h

    ; Load 0x100000 - 0x1000FF (config table)
    xor ax, ax
    mov es, ax
    mov di, 0xFF

    mov ds, ax
    mov si, 1

    xor dx, dx
    mov cx, 0x1F00 ; 0x1F00 + 0xFF = 0x1FFF (right before 0x2000)
    call l16_load_from_disk

    mov ax, l16_config_disk_offset

.hang:
    cli
    hlt
    jmp .hang