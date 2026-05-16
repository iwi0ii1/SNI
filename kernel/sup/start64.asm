bits 64
global _start64

extern sup_idt_init
extern hdp_init
extern hap_init
extern core_init

section .bss
align 16
stack_bottom:       ; Lower address
    resb 4096 * 8   ; Stack capacity: 32KB
stack_top:          ; Higher address



section .text
_start64:
    mov rsp, stack_top
    and rsp, -16

    call sup_idt_init

    call hdp_init
    call hap_init
    call core_init

    sti

    ; Testing #DE
    mov rax, 1
    xor rcx, rax
    idiv rcx

    ; Call the entrypoint of OS here

    cli
    jmp .hang

.hang:
    hlt
    jmp .hang