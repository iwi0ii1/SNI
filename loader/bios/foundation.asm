; Foundation stage of loader, MBR things. Load the next stages.

bits 16
org 0x7C00

ls_foundation: ; Stage 1 (MBR)
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7BFF



.inf:
    hlt
    jmp .inf