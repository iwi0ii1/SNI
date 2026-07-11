; Application stage of loader, read loader boot config, set env -> load kernel -> transition.

%include "bios/macros.inc"

bits 16

section .ls_application
ls_application: ; Stage 3
    

.inf:
    hlt
    jmp .inf
    
times 512 - ($ - $$) db 0 ; Same