; Application stage of loader, read loader boot config, set env -> load kernel -> transition.

bits 16

section .ls_application
ls_application: ; Stage 3
    ; Jobs here...

.inf:
    hlt
    jmp .inf