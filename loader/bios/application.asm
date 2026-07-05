; Application stage of loader, read loader boot config, set env -> load kernel -> transition.

bits 16
org 0x8000

ls_application: ; Stage 3
    ; Application

.inf:
    hlt
    jmp .inf