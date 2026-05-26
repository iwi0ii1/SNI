%include "hdp/private/shared/vgatb.inc"         ; Somehow NASM includes by the assembling point (which is kernel/)

bits 64
global hdp_init

extern hdp_acpi_init
extern hdp_pci_init

section .rodata
mstr: db "It works!!"

section .text
hdp_init:
    xor dil, dil
    call hdp_shared_fill_vgatb

    mov rax, 1
    call .hdp_test_plooper

    call hdp_acpi_init
    call hdp_pci_init

    ret

.hdp_test_plooper:
    mov rdi, rax
    mov sil, 0x0F
    call hdp_shared_putc
    inc rax

    cmp rax, 255
    jb .hdp_test_plooper

    ret