; Prepare long mode. Then far jump to `_start64`

bits 32
global _start

extern sup_gdt_init
extern sup_idt_init
extern sup_paging_init

extern _start64

section .bss
align 16
stack_bottom:       ; Lower address
    resb 4096 * 8   ; Stack capacity: 32KB
stack_top:          ; Higher address

section .text
_start:
    cli

    mov esp, stack_top
    and esp, -16

    ; Setup GDT
    call sup_gdt_init
    
    mov eax, cr4
    or eax, (1 << 5)
    mov cr4, eax

    ; Setup page
    call sup_paging_init

    mov ecx, 0xC0000080
    rdmsr
    or eax, (1 << 8)
    wrmsr

    mov eax, cr0
    or eax, (1 << 31)
    mov cr0, eax

    ; Far jump to _start64
    jmp 0x8:_start64