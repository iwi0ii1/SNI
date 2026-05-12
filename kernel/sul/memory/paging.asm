bits 64
global paging_init
global pml4

section .bss
align 4096
pml4:
    resq 512

pdpt:
    resq 512

pd:
    resq 512

section .text

paging_init:
    ; link tables
    mov rax, pdpt
    or rax, 0x3
    mov [pml4], rax

    mov rax, pd
    or rax, 0x3
    mov [pdpt], rax

    ; identity map 1GB (2MB pages)
    mov rcx, 0
.map:
    mov rax, rcx
    shl rax, 21          ; *2MB
    or rax, 0x83         ; present + writable + large page
    mov [pd + rcx*8], rax

    inc rcx
    cmp rcx, 512
    jne .map

    ; load CR3
    lea rax, [rel pml4]
    mov cr3, rax

    ret