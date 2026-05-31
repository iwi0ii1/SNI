%include "shared/vgatb.inc"         ; Somehow NASM includes by the assembling point (which is kernel/)

bits 64
global hdp_init

extern hdp_acpi_init
extern hdp_pci_init

section .rodata
mstr: db "It doesn't works!!"

section .text
hdp_init:
    xor dil, dil
    call hdp_shared_fill_vgatb

    call hdp_acpi_init
    call hdp_pci_init

    ret