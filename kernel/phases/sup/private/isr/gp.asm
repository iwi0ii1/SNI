; ISR of #GP (General Protection)

bits 64
global sup_isr_gp

section .rodata
error_msg: db "Kernel error: General Protection Fault!", 0

section .text
sup_isr_gp:
    cli

    mov rsi, error_msg
    mov rdi, 0xB8000
    mov ah, 0x0F

    jmp .print_loop

.print_loop:
    mov al, [rsi]
    test al, al        ; if AL == 0
    jz .done

    mov [rdi], ax
    add rdi, 2
    inc rsi
    jmp .print_loop

.done:
    ;iretq

.hang:
    hlt
    jmp .hang