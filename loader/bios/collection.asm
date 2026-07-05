; Collection stage of loader, collect e820, boot disk, VBE, loader boot config (sector 2048), etc.

bits 16
org 0x7E00

ls_collection: ; Stage 2
    mov ax, 0xB800
    mov es, ax
    mov word [es:2], 0xF041

    jmp 0x8000

.inf:
    hlt
    jmp .inf