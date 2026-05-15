; Prepare long mode. Then call other phases' init.

bits 32
global _start

extern sup_gdt_init
extern sup_idt_init
extern sup_paging_init

section .bss
align 16
stack_bottom:       ; Lower address
    resb 4096 * 8
stack_top:          ; Higher address

section .text
_start:
    mov esp, stack_top
    and esp, -16

    call sup_gdt_init
    
    mov eax, cr4
    or eax, (1 << 5)
    mov cr4, eax

    call sup_paging_init

    mov ecx, 0xC0000080
    rdmsr
    or eax, (1 << 8)
    wrmsr

    mov eax, cr0
    or eax, (1 << 31)
    mov cr0, eax


    jmp 0x8:_start64


bits 64
extern hdp_init
extern hap_init
extern core_init

_start64:
    call sup_idt_init

    call hdp_init
    call hap_init
    call core_init

    ; Call the entrypoint of OS here

    jmp .hang

.hang:
    hlt
    jmp .hang