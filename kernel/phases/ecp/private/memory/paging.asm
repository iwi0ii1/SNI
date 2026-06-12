; Repage memory since entering 64-bit requires that to happen.
; Sets EAX to address of PML4

bits 32
global ecp_paging_init

section .bss
align 4096
pml4: resb 4096
pdpt: resb 4096
; Allocate 6 Page Directories to cover exactly 6 GiB of memory space
pd_tables: resb 4096 * 6 

section .text
ecp_paging_init:
    ; Zero out all allocated tables (PML4 + PDPT + 6 PDs = 8 tables total)
    mov ax, 0x28    ; Kernel data selector
    mov es, ax

    mov edi, pml4
    mov ecx, (4096 * 8) / 4
    xor eax, eax
    rep stosd

    ; PML4[0] -> PDPT
    mov eax, pdpt
    or eax, 0x3          ; present + writable
    mov dword [pml4], eax
    mov dword [pml4 + 4], 0

    ; Link the 6 Page Directory tables into PDPT entries 0 through 5
    mov ecx, 0

.link_pdpt:
    mov eax, ecx
    shl eax, 12          ; ecx * 4096 (offset to next PD table)
    add eax, pd_tables   ; absolute physical address of this PD
    or eax, 0x3          ; present + writable
    
    mov dword [pdpt + ecx * 8], eax
    mov dword [pdpt + ecx * 8 + 4], 0
    
    inc ecx
    cmp ecx, 6           ; Link 6 directories (0 to 5 GiB range)
    jne .link_pdpt

    ; Identity map all 6 GiB using 2MiB huge pages
    ; Total pages to map = 6 GiB / 2 MiB = 3072 pages
    mov ecx, 0           ; Page counter index (0 to 3071)

.map_pd:
    mov eax, ecx
    shl eax, 21          ; ecx * 2MiB physical address generation
    or eax, 0x9B         ; present + writable + huge page + PWT + PCD (Cache Disabled by default!)
    
    mov dword [pd_tables + ecx * 8], eax
    mov dword [pd_tables + ecx * 8 + 4], 0

    inc ecx
    cmp ecx, 3072        ; 512 entries * 6 tables = 3072 total slots
    jne .map_pd

    ; Load CR3 with your root PML4 physical pointer
    mov eax, pml4
    mov cr3, eax

    ret