; Preparation stage of loader, basically just codes for setting the environment depends on the boot config.

%include "bios/macros.inc"

%define LS_PREPARATION_COMMONSTR "> Loader preparation stage: "

bits 16
org 0x8000

section .ls_preparation
ls_preparation:
    ; Define the bootcfg format...
    mov si, .tell_unready_str
    mov ax, 160
    call print_str ; Defined in collection stage.

    jmp 0x8200 ; Jump to Handoff stage

.tell_unready_str: db LS_PREPARATION_COMMONSTR, "not ready yet. Stay tuned for 2 months... (FAHHHHHHHHH)", 0

%include "bios/shared.inc"

times 512 - ($ - $$) db 0