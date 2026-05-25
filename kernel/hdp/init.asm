%include "hdp/private/shared/print_str.inc"     ; Somehow, NASM doesn't include by the current directory.
%include "hdp/private/shared/fill_vgatb.inc"

bits 64
global hdp_init

extern hdp_acpi_init
extern hdp_pci_init

section .rodata
mstr: db "Hello from hdp_init!", 0

section .text
hdp_init:
    mov dil, 0xFF
    call fill_vgatb

    mov rdi, mstr
    mov sil, 0xF0
    call print_str

    ;call hdp_acpi_init
    ;call hdp_pci_init

    ret