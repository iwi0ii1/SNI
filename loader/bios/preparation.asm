; Preparation stage of loader, basically just codes for setting the environment depends on the boot config.

%include "bios/macros.inc"

%define LS_PREPARATION_COMMONSTR "> Loader preparation stage: "

bits 16

section .ls_preparation:
ls_preparation:
    ; Hard... plan first.
    mov si, .tell_unready_str
    mov ax, 160
    call print_str ; Defined in collection stage.

    jmp 0x8200 ; Unreachable so far

.tell_unready_str: db LS_PREPARATION_COMMONSTR, "not ready yet.", 0

times 512 - ($ - $$) db 0