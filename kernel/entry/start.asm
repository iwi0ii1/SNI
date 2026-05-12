bits 64
global _start


extern sul_entry
extern hdl_entry
extern hal_entry
extern core_entry

section .text
_start:
    call sul_entry
    call hdl_entry
    call hal_entry
    call core_entry

.hang:
    cli
    hlt
    jmp .hang