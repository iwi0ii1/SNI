bits 64
global gdt_init
global gdt_ptr

section .data
; The definition
gdt_definition_start:
    dq 0x0000000000000000    ; null
    dq 0x002F9A000000FFFF    ; 64-bit Code (0x08)
    dq 0x000092000000FFFF    ; 64-bit Data (0x10)
gdt_definition_end:

gdt_ptr:
    dw gdt_definition_end - gdt_definition_start - 1
    dq gdt_definition_start
    



section .text
gdt_init:
    lgdt [gdt_ptr]

    mov ax, 0x10

    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax

    mov rax, .flush

    cmp rax, 0x2
    je .hng

    push qword 0x08

    push rax
    jmp .flush

.flush:
    mov rax, 0xDEADC0DE
    hlt

.hng:
    hlt
    jmp .hng