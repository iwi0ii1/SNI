; A table that maps interrupts to different handlers...

bits 64
global ecp_idt_init
global ecp_idt_set_handler

extern ecp_default_isr_de
extern ecp_default_isr_db
extern ecp_default_isr_nmi
extern ecp_default_isr_nm
extern ecp_default_isr_bp
extern ecp_default_isr_of
extern ecp_default_isr_ud
extern ecp_default_isr_df
extern ecp_default_isr_gp
extern ecp_default_isr_pf

section .bss
align 16
ecp_idt_table:
    resb 256 * 16       ; 256 slots for different kind of interrupts

section .data
ecp_idt_fmt_ptr:            ; Just a fucking lidt format piece of shit
    dw 256 * 16 - 1
    dq ecp_idt_table



section .text
; Install IDT so interrupts work.
ecp_idt_init:
    cli

    ; Zero all slots for handlers in table
    lea rdi, [rel ecp_idt_table]
    xor rax, rax
    mov rcx, 512
    rep stosq           ; Call stosq 512 times (thx to rcx)


    ; #DE
    mov rdi, ecp_default_isr_de
    mov si, 0
    call ecp_idt_set_handler

    ; #DB
    mov rdi, ecp_default_isr_db
    mov si, 1
    call ecp_idt_set_handler

    ; NMI (Critical)
    mov rdi, ecp_default_isr_nmi
    mov si, 2
    call ecp_idt_set_handler

    ; #BP
    mov rdi, ecp_default_isr_bp
    mov si, 3
    call ecp_idt_set_handler

    ; #OF
    mov rdi, ecp_default_isr_of
    mov si, 4
    call ecp_idt_set_handler

    ; #UD
    mov rdi, ecp_default_isr_ud
    mov si, 5
    call ecp_idt_set_handler

    ; #DF
    mov rdi, ecp_default_isr_df
    mov si, 6
    call ecp_idt_set_handler

    ; #NM
    mov rdi, ecp_default_isr_nm
    mov si, 7
    call ecp_idt_set_handler

    ; #GP
    mov rdi, ecp_default_isr_gp
    mov si, 13
    call ecp_idt_set_handler

    ; #PF
    mov rdi, ecp_default_isr_pf
    mov si, 14
    call ecp_idt_set_handler

    ; Set IDT to this.
    lidt [ecp_idt_fmt_ptr]

    ret


; Set a handler for a specific vector (RDI: handler address, SI: vector index)
; Reminds: This label is being depended by `api/interrupts.asm` for a macro about registering ISR
ecp_idt_set_handler:
    lea rdx, [rel ecp_idt_table]

    mov rax, rdi
    shl si, 4
    movzx rsi, si
    add rdx, rsi

    mov rcx, rax        ; keep original safe copy

    ; offset 0..15
    mov word [rdx + 0], cx

    ; selector
    mov word [rdx + 2], 0x08

    ; flags
    mov byte [rdx + 4], 0
    mov byte [rdx + 5], 0x8E

    ; offset 16..31
    mov rax, rcx
    shr rax, 16
    mov word [rdx + 6], ax

    ; offset 32..63 (FIXED: clean extraction, not chained shifts)
    mov rax, rcx
    shr rax, 32
    mov dword [rdx + 8], eax

    ; reserved
    mov dword [rdx + 12], 0
    ret



probe_idt_pf:
    lea rsi, [rel ecp_idt_table + 14 * 16]

    ; rebuild handler address from IDT entry
    xor rax, rax

    mov ax, [rsi + 0]      ; offset 0..15
    mov dx, [rsi + 6]      ; offset 16..31

    shl rdx, 16
    or rax, rdx

    mov edx, [rsi + 8]     ; offset 32..63
    shl rdx, 32
    or rax, rdx

    ; now RAX = handler from IDT

    mov rbx, ecp_default_isr_pf    ; expected handler

    cmp rax, rbx
    je .ok

.bad:
    mov byte [0xB8000], 'X'
    hlt

.ok:
    mov byte [0xB8000], 'O'
    hlt