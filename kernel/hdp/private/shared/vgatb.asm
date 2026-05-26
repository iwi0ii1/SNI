bits 64
global hdp_shared_putc
global hdp_shared_aputs
global hdp_shared_fill_vgatb
global hdp_shared_reposition_cursor
global hdp_shared_get_cursor_pos

section .data
cursor_pos: dw 0





section .text
hdp_shared_putc:
    movzx rax, word [cursor_pos]
    cmp rax, 2000
    jae .end

    mov al, dil          ; char directly in rdi
    test al, al
    jz .end

    movzx bx, sil
    shl bx, 8
    or bl, al

    mov rcx, 0xB8000
    movzx rax, word [cursor_pos]
    shl rax, 1
    add rcx, rax

    mov word [rcx], bx
    inc word [cursor_pos]

.end:
    ret



hdp_shared_aputs:
    mov al, [rdi]        ; get char
    test al, al          ; al == 0
    jz .end

    movzx bx, sil
    shl bx, 8
    or bl, al            ; better than mov bl, al

    mov rcx, 0xB8000
    movzx rax, word [cursor_pos]
    shl rax, 1           ; Don't use IMUL, better to use left shift
    add rcx, rax

    mov word [rcx], bx

    inc rdi
    inc word [cursor_pos]

    movzx rax, word [cursor_pos]
    cmp rax, 2000
    jb hdp_shared_aputs

    mov word [cursor_pos], 0
    call .scroll        ; Only reachable if RAX is greater than 2000

    jmp hdp_shared_aputs

.scroll:
    ; Set RCX to VGATB address according to `cursor_pos`
    mov rcx, 0xB8000
    movzx rax, word [cursor_pos]
    shl rax, 1              ; Don't use IMUL, better to use left shift
    add rcx, rax

    mov ax, [rcx + 160]     ; This is allowed as x86 has complex addressing mode
    mov word [rcx], ax

    inc word [cursor_pos]

    movzx rax, word [cursor_pos]
    cmp rax, 1920
    jae .end
    
    jmp .scroll

.end:
    ret



hdp_shared_fill_vgatb:
    mov rcx, 0xB8000
    jmp .lup

.lup:
    ; DIL requires REX prefix, so... use ax for it since ax has more space.
    movzx ax, dil             ; 8-bit version of RDI

    shl ax, 8
    or ax, ' '   

    mov word [rcx], ax

    add rcx, 2

    cmp rcx, (0xB8000 + 4000)   ; B8FA0, stop at start of last cell
    jae .end
    
    jmp .lup

.end:
    ret



hdp_shared_get_cursor_pos:
    ; Formula: offset / 80
    ; Quotient: Row (y)
    ; Remainder: Col (x)

    ; For DIV, AX for dividend, CX for divisor, DX is where the remainder go
    mov ax, [cursor_pos]
    mov cx, 80
    xor dx, dx
    div cx

    ; Result:
    ; AX: y (max 25)
    ; DX: x (max 80)

    shl ax, 8
    or ax, dx

    ret



hdp_shared_reposition_cursor:
    ; Formula: (y << 6) + (y << 4) + x
    mov ax, si
    shl ax, 6        ; y * 64

    mov dx, si
    shl dx, 4        ; y * 16

    add ax, dx      ; y * 80
    add ax, di      ; + x

    mov word [cursor_pos], ax

    ret