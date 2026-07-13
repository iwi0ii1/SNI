; Handoff stage of loader, read boot settings, choose to set the env, and load it.

%include "bios/macros.inc"

%define LS_HANDOFF_COMMONSTR "> Loader handoff stage: "

bits 16

section .ls_handoff
ls_handoff:
    mov word [0xB80FF], 0x0F41
    ; Hard... plan first.
    mov si, .tell_unready_str
    mov ax, 240
    call print_str ; Defined in collection stage.

.hang:
    hlt
    jmp .hang

.tell_unready_str: db LS_HANDOFF_COMMONSTR, "not ready yet.", 0
    
times 512 - ($ - $$) db 0 ; Same