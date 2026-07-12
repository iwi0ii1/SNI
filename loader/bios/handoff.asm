; Handoff stage of loader, read boot settings, choose to set the env, and load it.

%include "bios/macros.inc"

bits 16

section .ls_handoff
ls_handoff:
    ; Hard... plan first.

.inf:
    hlt
    jmp .inf
    
times 512 - ($ - $$) db 0 ; Same