; Common things for the default ISRs (can't use `shared/` bc stack might be broken)
bits 64

section .text
; Parameters: RDI for msg ptr, SIL for color attr
ecp_default_isr_shared_print_and_hang:
    cli

    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11

    mov rcx, 0xB8000
    movzx ax, sil
    shl ax, 8

.print_loop:
    mov al, [rdi]
    test al, al
    jz .done

    mov [rcx], ax
    add rcx, 2
    inc rdi
    jmp .print_loop

.done:
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax

.hang:
    hlt
    jmp .hang