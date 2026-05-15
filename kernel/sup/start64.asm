bits 64
global _start64

extern sup_idt_init
extern hdp_init
extern hap_init
extern core_init

section .text
_start64:
    call sup_idt_init

    call hdp_init
    call hap_init
    call core_init

    sti

    ; NULL dereference for test, cuh.
    mov rax, 0
    mov [rax], 123

    ; Call the entrypoint of OS here

    cli
    jmp .hang

.hang:
    hlt
    jmp .hang

.paging_on:
    cli

    mov rax, 0xB8000
    mov word [rax], 0x458F
    jmp .hang