; Long mode entrypoint
%include "phases/ecp/private/exposed.inc"

bits 64
global _start64

extern ecp_modes_enable_mmx
extern ecp_modes_enable_sse

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
    call ecp_idt_init

.enable_sse_mmx: ; Enable SSE and MMX
    call ecp_modes_enable_sse
    call ecp_modes_enable_mmx

    and rsp, -16 ; Align stack for movaps

    ; Clear SIMD registers
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

.init_phases:
    call hdp_init
    call hap_init
    call rtp_init

    sti

    ; User space

    cli
    jmp .hang

.hang:
    hlt
    jmp .hang