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

    call sup_gdt_init    ; Setup GDT (Ensures sup_gdt_ptr is 'dd', flushes CS)
    call sup_paging_init ; Setup page tables (Ensures ES is 0x28, returns PML4 address in EAX)
    
    ; Enable CR4.PAE, prepares CPU for 4-level/64-bit tables
    mov edx, cr4
    or edx, (1 << 5)     ; PAE bit
    mov cr4, edx

    ; Load CR3 with the PML4 table address returned in EAX
    mov cr3, eax

    ; Enable "Long Mode Enable" (LME) in the EFER MSR
    mov ecx, 0xC0000080
    rdmsr ; Read MSR
    or eax, (1 << 8)     ; LME bit
    wrmsr ; Write MSR

    ; Enable Paging. The moment this completes, Long Mode Active (LMA) engages.
    mov eax, cr0
    or eax, (1 << 31)    ; PG bit
    mov cr0, eax

    ; Clear the runway and make the jump to 64-bit space!
    jmp 0x8:_start64