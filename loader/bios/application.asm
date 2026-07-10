; Application stage of loader, read loader boot config, set env -> load kernel -> transition.

bits 16

section .ls_application
ls_application: ; Stage 3
    mov ax, 0xB81E
    mov es, ax
    mov word [es:0], 0xF041

.inf:
    hlt
    jmp .inf
    
times 512 - ($ - $$) db 0 ; Same