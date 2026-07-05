; Collection stage of loader, collect e820, boot disk, VBE, loader boot config (sector 2048), etc.

bits 16
org 0x7E00

ls_collection: ; Stage 2
    ; Collect infos

.inf:
    hlt
    jmp .inf