bits 32
global _start
extern _start64

; Boot Data Structure (Will be abandoned after far jump)
section .data
align 4096
boot_pml4: times 4096 db 0
boot_pdpt: times 4096 db 0
boot_pd: times 4096 db 0


align 16
gdt32_start:
    dq 0x0000000000000000  ; Null descriptor
    dq 0x00cf9a000000ffff  ; 32-bit Protected Mode Code (Index 0x08)
    dq 0x00cf92000000ffff  ; 32-bit Protected Mode Data (Index 0x10)
    dq 0x00209a0000000000  ; Full x86_64 Long Mode Code (Index 0x18)
gdt32_end:

gdt32_ptr:
    dw gdt32_end - gdt32_start - 1
    dd gdt32_start



section .bss
align 16
boot_stack_bottom:
    resb 4096              ; Small 4KB stack just for this file
boot_stack_top:



section .text
_start:
    cld 
    cli

    ; 1. Set up your 32-bit stack
    mov esp, boot_stack_top
    and esp, -16

    ; 2. Initialize the identity paging bridge (Maps first 2MB)
    ; Clear tables first (equivalent to your loop test logic)
    mov edi, boot_pml4
    mov ecx, 3072          ; Clear PML4, PDPT, and PD (1024 dwords each)
    xor eax, eax
    rep stosd

    ; Link PML4[0] -> boot_pdpt
    mov eax, boot_pdpt
    or eax, 0x3            ; Present + Read/Write
    mov [boot_pml4], eax

    ; Link PDPT[0] -> boot_pd
    mov eax, boot_pd
    or eax, 0x3            ; Present + Read/Write
    mov [boot_pdpt], eax

    ; Link PD[0] -> Physical Address 0x0 as a 2MB Huge Page
    mov eax, 0x0
    or eax, 0x83           ; Present + Read/Write + Huge Page (Bit 7)
    mov [boot_pd], eax

    ; 3. Load the 32-bit GDT 
    lgdt [gdt32_ptr]

    ; 4. Enable PAE and load CR3 with our boot table
    mov edx, cr4
    or edx, (1 << 5)       ; PAE bit
    mov cr4, edx

    mov eax, boot_pml4
    mov cr3, eax

    ; 5. Enable Long Mode Enable (LME) in EFER MSR
    mov ecx, 0xC0000080
    rdmsr
    or eax, (1 << 8)       ; LME bit
    wrmsr

    ; 6. Flip the Paging Bit (Engages 64-bit Long Mode Active)
    mov eax, cr0
    or eax, (1 << 31)      ; PG bit
    mov cr0, eax

    ; 7. Execute the far jump into 64-bit space! 
    jmp 0x18:_start64

.hang:
    hlt
    jmp .hang