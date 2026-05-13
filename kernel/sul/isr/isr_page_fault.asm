bits 64
global isr_page_fault

section .rodata
error_msg: db "ISR Page fault reached!", 0

section .text
isr_page_fault:
    cli

    mov rsi, error_msg
    mov rdi, 0xB8000
    mov ah, 0x0F

.print:
    mov al, [rsi]
    test al, al
    jz .hang

    mov [rdi], ax
    add rdi, 2
    inc rsi
    jmp .print

.hang:
    hlt
    jmp .hang