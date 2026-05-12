bits 64
global _start


extern sul_init
extern hdl_init
extern hal_init
extern core_init

section .text
_start:
    call sul_init
    call hdl_init
    call hal_init
    call core_init

.hang:
    cli
    hlt
    jmp .hang