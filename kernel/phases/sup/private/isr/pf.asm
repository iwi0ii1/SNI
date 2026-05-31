; ISR of #PF (Page Fault)

bits 64
global sup_isr_pf

section .rodata
error_msg: db "Kernel error: Page fault!", 0

section .text
sup_isr_pf:
    cli

    mov rsi, error_msg
    mov rdi, 0xB8000
    mov ah, 0x0F

    jmp .print_loop

.print_loop:
    mov al, [rsi]
    test al, al        ; This checks if AL is 0... it is the same as cmp al, 0 but faster.
    jz .hang

    mov [rdi], ax
    add rdi, 2
    inc rsi
    jmp .print_loop

.hang:
    hlt
    jmp .hang

; Note: Cannot use `call` or anything stack related in ISR,
; don't expect fault to not be related to stack, you don't know.