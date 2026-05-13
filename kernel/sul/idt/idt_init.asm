bits 64
global idt_init
global idt_ptr

extern isr_page_fault

section .bss
align 16
idt_storage:
    resb 256 * 16       ; 256 slots for different kind of interrupts

section .data
idt_fmt_ptr:            ; Just a fucking lidt format piece of shit
    dw 256 * 16 - 1
    dq idt_storage



section .text
idt_init:
    ; example: zero IDT first
    lea rdi, [rel idt_storage]
    xor rax, rax
    mov rcx, 512
    rep stosq           ; Call stosq 512 times (thx to rcx)

    ; Assign `isr_page_fault` to vector 14 (Page Fault)
    mov rax, isr_page_fault
    mov rbx, 14
    call idt_set_handler


    lidt [idt_fmt_ptr]

    ret

; Set a handler for a specific vector (rax: handler, rbx: vector index)
idt_set_handler:
    lea rdi, [idt_storage + rbx * 16]

    mov word [rdi], 0x08
    mov word [rdi + 2], 0x08
    mov byte [rdi + 4], 0
    mov byte [rdi + 5], 0x8E

    shr rax, 16
    mov word [rdi + 6], ax
    shr rax, 16
    mov dword [rdi + 8], eax
    mov dword [rdi + 12], 0

    ret