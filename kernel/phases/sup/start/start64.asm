; See `start.asm`to understand

bits 64
global _start64

extern sup_idt_init

extern hdp_init
extern hap_init
extern rtp_init

section .bss
align 16
stack_bottom:       ; Lower address (LAST PLATE)
    resb 4096 * 8   ; Stack capacity: 32KB
stack_top:          ; Higher address (NOT THE FIRST PLATE, BUT THE COVER OF THE PLATES SET)



section .text
_start64:
    cld ; Clear Direction Flag (so things don't go backwards)

.reload_segment_regs:
    ; Reload ALL data segment registers for 64-bit mode rules
    mov ax, 0x28        ; 0x28 is gdt_kernel_data selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax          ; Safely lock down the 64-bit Stack Segment

.set_stack:
    mov rsp, stack_top
    and rsp, -16

    %ifdef DEBUG_FORM
    mov rax, stack_top
    cmp rax, 0x40000000
    jg .hang

    ; Stack test
    mov rax, 0x1122334455667788
    sub rsp, 8
    mov [rsp], rax
    mov rcx, 0x1122334455667788
    mov rax, [rsp]
    cmp rax, rcx ; Somehow CMP doesn't take 64-bit immediate
    jne .hang

    ; ===== REP STOS TEST =====

    mov rdi, rsp        ; destination = stack
    mov rcx, 512        ; write 512 qwords (4KB total)
    xor rax, rax        ; value = 0

    rep stosq           ; THIS is what `{0}` uses
    %endif

.tss_shit:
    ; Immediately force the CPU cache into 16-byte 64-bit TSS rules
    mov ax, 0x38        ; 0x38 is your selector
    ltr ax              ; The hardware re-reads the full 16-byte layout cleanly

.init_idt:
    call sup_idt_init

.enable_sse_mmx:
    ; Enable SSE/MMX
    mov rax, cr0
    and rax, ~(1 << 2)   ; clear EM (bit 2)
    or  rax, (1 << 1)    ; set MP (bit 1)
    mov cr0, rax

    mov rax, cr4
    or  rax, (1 << 9)    ; OSFXSR (bit 9) - enable fxsave/fxrstor
    or  rax, (1 << 10)   ; OSXMMEXCPT (bit 10) - enable SSE exceptions
    mov cr4, rax

    ; --- Align stack for movaps ---
    and rsp, -16

    ; --- Clear SIMD registers ---
    pxor xmm0, xmm0
    pxor xmm1, xmm1
    pxor xmm2, xmm2
    pxor xmm3, xmm3
    pxor xmm4, xmm4
    pxor xmm5, xmm5
    pxor xmm6, xmm6
    pxor xmm7, xmm7
    pxor xmm8, xmm8
    pxor xmm9, xmm9
    pxor xmm10, xmm10
    pxor xmm11, xmm11
    pxor xmm12, xmm12
    pxor xmm13, xmm13
    pxor xmm14, xmm14
    pxor xmm15, xmm15
    ;pxor xmm16, xmm16
    ;pxor xmm17, xmm17
    ;pxor xmm18, xmm18
    ;pxor xmm19, xmm19
    ;pxor xmm20, xmm20
    ;pxor xmm21, xmm21
    ;pxor xmm22, xmm22
    ;pxor xmm23, xmm23
    ;pxor xmm24, xmm24
    ;pxor xmm25, xmm25
    ;pxor xmm26, xmm26
    ;pxor xmm27, xmm27
    ;pxor xmm28, xmm28
    ;pxor xmm29, xmm29
    ;pxor xmm30, xmm30
    ;pxor xmm31, xmm31

.init_phases:
    call hdp_init
    call hap_init
    call rtp_init

    sti

    
    ; Spawn init (PID 1) here.

    cli
    jmp .hang

.hang:
    hlt
    jmp .hang