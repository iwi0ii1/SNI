; A table that maps interrupts to different handlers...
; Like `int 0xE (14)` -> calls `sup_isr_page_fault`

bits 64
global sup_idt_init
global sup_idt_set_handler

extern sup_isr_de
extern sup_isr_db
extern sup_isr_nmi
extern sup_isr_bp
extern sup_isr_of
extern sup_isr_ud
extern sup_isr_df
extern sup_isr_gp
extern sup_isr_pf

section .bss
align 16
sup_idt_table:
    resb 256 * 16       ; 256 slots for different kind of interrupts

section .data
sup_idt_fmt_ptr:            ; Just a fucking lidt format piece of shit
    dw 256 * 16 - 1
    dq sup_idt_table



section .text
sup_idt_init:
    cli

    ; Zero all slots for handlers in table
    lea rdi, [rel sup_idt_table]
    xor rax, rax
    mov rcx, 512
    rep stosq           ; Call stosq 512 times (thx to rcx)


    ; #DE
    mov rax, sup_isr_de
    mov rbx, 0
    call sup_idt_set_handler

    ; #DB
    mov rax, sup_isr_db
    mov rbx, 1
    call sup_idt_set_handler

    ; NMI (Critical)
    mov rax, sup_isr_nmi
    call rbx, 2
    call sup_idt_set_handler

    ; #BP
    mov rax, sup_isr_bp
    mov rbx, 3
    call sup_idt_set_handler

    ; #OF
    mov rax, sup_isr_of
    mov rbx, 4
    call sup_idt_set_handler

    ; #UD
    mov rax, sup_isr_ud
    mov rbx, 5
    call sup_idt_set_handler

    ; #DF
    mov rax, sup_isr_df
    mov rbx, 6
    call sup_idt_set_handler

    ; #GP
    mov rax, sup_isr_gp
    mov rbx, 13
    call sup_idt_set_handler

    ; #PF
    mov rax, sup_isr_pf
    mov rbx, 14
    call sup_idt_set_handler

    

    ; Set IDT to this.
    lidt [sup_idt_fmt_ptr]

    ret


; Set a handler for a specific vector (rax: handler, rbx: vector index)
; Reminds: This label is being depended by `api/interrupts.asm` for a macro about registering ISR
sup_idt_set_handler:
    lea rdi, [rel sup_idt_table]
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