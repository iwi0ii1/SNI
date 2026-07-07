; Application stage of loader, read loader boot config, set env -> load kernel -> transition.

bits 16

section .ls_application
ls_application: ; Stage 3
    mov ax, 0xB800
    mov es, ax
    mov word [es:4], 0xF041

.inf:
    hlt
    jmp .inf