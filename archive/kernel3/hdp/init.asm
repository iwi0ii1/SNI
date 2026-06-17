%include "hdp/private/exposed.inc"
%include "shared/vgatb.inc"         ; Somehow NASM includes by the assembling point (which is kernel/)

bits 64
global hdp_init

section .rodata
mstr: db "It doesn't works!!", 0

section .text
hdp_init:
    mov dil, ' '
    xor sil, sil
    call shared_vgatb_fill_char

    call hdp_acpi_init
    call hdp_pci_init

    hlt

    ret