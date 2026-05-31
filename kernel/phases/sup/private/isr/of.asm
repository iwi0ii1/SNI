; ISR of #OF (OverFlow)

bits 64
global sup_isr_of

section .rodata
error_msg: db "Kernel error: Overflown!", 0

section .text
sup_isr_of:
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