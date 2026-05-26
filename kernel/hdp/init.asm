%include "hdp/private/shared/vgatb.inc"         ; Somehow NASM includes by the assembling point (which is kernel/)

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

    mov rdi, mstr
    mov sil, 0x0F
    call hdp_shared_aputs

    call hdp_shared_newline_cursor

    mov rdi, mstr
    mov sil, 0x0F
    call hdp_shared_aputs

    ;call hdp_acpi_init
    ;call hdp_pci_init

    ret