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

    mov rax, cr0
    bt rax, 31
    jc .paging_on

    ; Call the entrypoint of OS here

    cli
    jmp .hang

.hang:
    hlt
    jmp .hang

.paging_on:
    mov word [0xB8000], 0x458F
    jmp .hang