; _start but 64-bit. And definitely after sul_init jumped here.
bits 64

global _start64

extern hdl_init
extern hal_init
extern core_init

section .text
_start64:
    call hdl_init
    call hal_init
    call core_init

    ; Call the entrypoint of OS here

    jmp .hang

.hang:
    hlt
    jmp .hang