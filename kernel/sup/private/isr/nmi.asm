; ISR of Non-Maskable Interrupt (NMI)
; This ISR is special as it cannot be cancelled and usually means smth very bad happened at hardware level.

bits 64
global sup_isr_nmi

section .rodata
fatal_msg: db "Kernel fatal: NMI reached!", 0

section .text
sup_isr_nmi:
    cli

    push rax
    push rdi
    push rsi

    mov rsi, fatal_msg
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