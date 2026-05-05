bits 64
global gdt_init
global gdt_ptr

section .data
gdt_start:
    dq 0x0000000000000000    ; null
    dq 0x00af9a000000ffff    ; Standard 64-bit Code
    dq 0x00af92000000ffff    ; Standard 64-bit Data
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dq gdt_start



section .text
gdt_init:
    lgdt [gdt_ptr]

    cmp rsp, 0x0
    jz .hng

    mov ax, 0x10

.hng
    hlt
    jmp .hng

    mov ds, ax
    mov es, ax
    mov ss, ax

    push qword 0x08
    lea rax, [rel .flush]
    push rax
    retfq

.flush:
    ret