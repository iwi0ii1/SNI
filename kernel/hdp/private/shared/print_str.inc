; HDP's VGATB string printer, include this directly, not extern it.
; Parameter: RDI for first char ptr
; Parameter: SIL for color attribute
; Note: String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)

bits 64

section .text
print_str:
    mov rcx, 0xB8000

.lup:
    mov al, [rdi]        ; get char
    test al, al
    jz .end              ; check FIRST (important)

    movzx bx, sil
    shl bx, 8
    or bl, al            ; safe combine (better than OR bx, ax)

    mov word [rcx], bx

    inc rdi
    add rcx, 2

    cmp rcx, (0xB8000 + 4000)   ; B8FA0, stop at start of last cell
    jae .end

    jmp .lup

.end:
    ret