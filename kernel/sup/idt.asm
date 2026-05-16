; A table that maps interrupts to different handlers...
; Like `int 0xE (14)` -> calls `sup_isr_page_fault`

bits 64
global sup_idt_init

extern sup_isr_divide_by_zero
extern sup_isr_general_protection_fault
extern sup_isr_page_fault

section .bss
align 16
sup_idt_storage:
    resb 256 * 16       ; 256 slots for different kind of interrupts

section .data
sup_idt_fmt_ptr:            ; Just a fucking lidt format piece of shit
    dw 256 * 16 - 1
    dq sup_idt_storage



section .text
sup_idt_init:
    cli

    ; Zero all slots for handlers in table
    lea rdi, [rel sup_idt_storage]
    xor rax, rax
    mov rcx, 512
    rep stosq           ; Call stosq 512 times (thx to rcx)



    ; Assign `sup_isr_divide_by_zero` to vector 0 (#DE)
    mov rax, sup_isr_divide_by_zero
    mov rbx, 0
    call sup_idt_set_handler

    ; Assign `sup_isr_general_protection_fault` to vector 13 (#GP)
    mov rax, sup_isr_general_protection_fault
    mov rbx, 0
    call sup_idt_set_handler

    ; Assign `sup_isr_page_fault` to vector 14 (#PF)
    mov rax, sup_isr_page_fault
    mov rbx, 14
    call sup_idt_set_handler

    

    ; Set IDT to this.
    lidt [sup_idt_fmt_ptr]

    ret

; Set a handler for a specific vector (rax: handler, rbx: vector index)
sup_idt_set_handler:
    lea rdi, [rel sup_idt_storage]
    shl rbx, 4          ; Multiply index by 16
    add rdi, rbx

    mov word [rdi], ax
    mov word [rdi + 2], 0x08
    mov byte [rdi + 4], 0
    mov byte [rdi + 5], 0x8E

    shr rax, 16
    mov word [rdi + 6], ax
    shr rax, 16
    mov dword [rdi + 8], eax
    mov dword [rdi + 12], 0

    ret