global _start
extern main



section .bss

align 4096
pml4_table:
    resb 4096
pdpt_table:
    resb 4096
pd_table:
    resb 4096



align 16
stack_bottom:
    resb 16384        ; 16 KB stack
stack_top:





section .text
bits 64
_start:
    /**
     * Setup stack
     */
    mov rsp, stack_top
    and rsp, -16

    cli
    cld



    /**
     * Zero page tables
     * (required, otherwise garbage mappings)
     */
    xor rax, rax
    lea rdi, [pml4_table]
    mov rcx, 4096/8
    rep stosq

    lea rdi, [pdpt_table]
    mov rcx, 4096/8
    rep stosq

    lea rdi, [pd_table]
    mov rcx, 4096/8
    rep stosq



    /**
     * Build identity mapping
     * (first 2MB using 2MB pages)
     */
    
    ; PML4[0] = PDPT
    lea rax, [pdpt_table]
    or rax, 0b11
    mov [pml4_table], rax

    ; PDPT[0] = PD
    lea rax, [pd_table]
    or rax, 0b11
    mov [pdpt_table], rax

    ; PD[0] = identity map 2MB page
    mov rax, 0x00000083        ; present + writable + huge page (2MB)
    mov [pd_table], rax



    /**
     * Load page tables
     */
    lea rax, [pml4_table]
    mov cr3, rax



    /**
     * Enable Long mode
     */
    mov rax, cr4
    or rax, (1 << 5)           ; PAE
    mov cr4, rax

    mov ecx, 0xC0000080        ; EFER
    rdmsr
    or eax, (1 << 8)           ; LME
    wrmsr

    mov rax, cr0
    or rax, (1 << 31)          ; PG
    or rax, (1 << 0)           ; PE
    mov cr0, rax



    /**
     * Safe transition to kernel
     */
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    call main

.hang:
    hlt
    jmp .hang