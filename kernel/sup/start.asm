; Prepare long mode. Then call other phases' init.

bits 32
global _start

extern hdp_init
extern hap_init
extern core_init

extern sup_gdt_init
extern sup_idt_init

section .bss
align 16
stack_bottom:       ; Lower address
    resb 4096 * 8
stack_top:          ; Higher address

section .text
_start:
    ; Prepare long mode
    mov rsp, stack_top
    and rsp, -16

    call sup_gdt_init
    call sup_idt_init

    
    ; Jump to call the rest of the phases
    jmp ._start64

._start64:
    call hdp_init
    call hap_init
    call core_init

    ; Call the entrypoint of OS here

    jmp .hang

.hang:
    hlt
    jmp .hang