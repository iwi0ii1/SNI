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
    ; identity map 1GB
    mov rcx, 0
.map:
    mov rax, rcx
    shl rax, 21
    or rax, 0x83
    mov [pd + rcx*8], rax

    inc rcx
    cmp rcx, 512
    jne .map

    mov rax, pdpt
    or rax, 0x3
    mov [pml4], rax

    mov rax, pd
    or rax, 0x3
    mov [pdpt], rax

    ; load CR3 LAST
    lea rax, [rel pml4]

    mov rax, 0x2F
    out 0xE9, al

    mov cr3, rax

    mov rax, 0x4F
    out 0xE9, al

    ret