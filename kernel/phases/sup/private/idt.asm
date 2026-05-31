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
    mov rdi, sup_isr_de
    mov si, 0
    call sup_idt_set_handler

    ; #DB
    mov rdi, sup_isr_db
    mov si, 1
    call sup_idt_set_handler

    ; NMI (Critical)
    mov rdi, sup_isr_nmi
    mov si, 2
    call sup_idt_set_handler

    ; #BP
    mov rdi, sup_isr_bp
    mov si, 3
    call sup_idt_set_handler

    ; #OF
    mov rdi, sup_isr_of
    mov si, 4
    call sup_idt_set_handler

    ; #UD
    mov rdi, sup_isr_ud
    mov si, 5
    call sup_idt_set_handler

    ; #DF
    mov rdi, sup_isr_df
    mov si, 6
    call sup_idt_set_handler

    ; #GP
    mov rdi, sup_isr_gp
    mov si, 13
    call sup_idt_set_handler

    ; #PF
    mov rdi, sup_isr_pf
    mov si, 14
    call sup_idt_set_handler

    

    ; Set IDT to this.
    lidt [sup_idt_fmt_ptr]

    ret


; Set a handler for a specific vector (rdi: handler address, si: vector index)
; Reminds: This label is being depended by `api/interrupts.asm` for a macro about registering ISR
sup_idt_set_handler:
    lea rdx, [rel sup_idt_table]
    shl si, 4          ; Multiply index by 16
    movzx rsi, si      ; Zero-extend SI
    add rdx, rsi

    mov word [rdx], di
    mov word [rdx + 2], 0x08
    mov byte [rdx + 4], 0
    mov byte [rdx + 5], 0x8E

    shr rdi, 16
    mov word [rdx + 6], di
    shr rdi, 16
    mov dword [rdx + 8], edi
    mov dword [rdx + 12], 0

    ret