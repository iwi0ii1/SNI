; Repage memory since entering 64-bit requires that to happen even when MB2 already did it for us in 32-bit mode. FUCK!!!!

bits 32
global sup_paging_init

section .bss
align 4096
pml4: resb 4096
pdpt: resb 4096
pd: resb 4096

section .text
sup_paging_init:
    ; zero tables (optional but recommended)
    mov edi, pml4
    mov ecx, (4096 * 3) / 4
    xor eax, eax
    rep stosd

    ; PML4[0] -> PDPT
    mov eax, pdpt
    or eax, 0x3          ; present + writable
    mov dword [pml4], eax
    mov dword [pml4 + 4], 0

    ; PDPT[0] -> PD
    mov eax, pd
    or eax, 0x3
    mov dword [pdpt], eax
    mov dword [pdpt + 4], 0

    ; identity map first 2MB using 2MB pages
    mov ecx, 0           ; page index
.map_pd:
    mov eax, ecx
    shl eax, 21          ; 2MB * index
    or eax, 0x83         ; present + writable + huge page
    mov dword [pd + ecx * 8], eax
    mov dword [(pd + ecx * 8) + 4], 0

    inc ecx
    cmp ecx, 1           ; Only map 2MB
    jne .map_pd

    ; load CR3 (PML4 physical address)
    mov eax, pml4
    mov cr3, eax

    ret