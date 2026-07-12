; Preparation stage of loader, basically just codes for setting the environment depends on the boot config.

%include "bios/macros.inc"

bits 16

section .ls_preparation:
ls_application:
    ; HARD!! PLAN FIRST!!!

.hang:
    cli
    hlt
    jmp .hang

times 512 - ($ - $$) db 0