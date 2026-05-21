; ISR of #DE (Divide Error)

bits 64
global sup_isr_de

section .rodata
error_msg: db "Kernel error: Divided by zero!", 0

section .text
sup_isr_de:
    cli

    push rax
    push rdi
    push rsi

    mov rsi, error_msg
    mov rdi, 0xB8000
    mov ah, 0x0F

.print_loop:
    mov al, [rsi]
    test al, al
    jz .done

    mov [rdi], ax
    add rdi, 2
    inc rsi
    jmp .print_loop

.done:
    pop rsi
    pop rdi
    pop rax

.hang:
    hlt
    jmp .hang