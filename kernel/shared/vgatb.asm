bits 64
global hdp_shared_putc
global hdp_shared_aputs
global hdp_shared_fill_vgatb
global hdp_shared_get_cursor_pos
global hdp_shared_reposition_cursor
global hdp_shared_newline_cursor

section .data
cursor_pos: dw 0





section .text
hdp_shared_internal_scroll:
    mov rsi, 0xB8000 + 160        ; source = row 1
    mov rdi, 0xB8000              ; dest   = row 0
    mov ecx, 24 * 80              ; 24 rows * 80 chars
    rep movsw                     ; copy words upward

    ; clear last row
    mov ecx, 80
    mov ax, 0x0720                ; ' ' with attribute

.clear_loop:
    stosw
    loop .clear_loop

    movzx eax, word [cursor_pos]
    cmp eax, 80
    jb .clamp                     ; if cursor_pos < 80, then set to 0

    sub word [cursor_pos], 80
    ret

.clamp:
    mov word [cursor_pos], 0
    ret



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
    call hdp_shared_internal_scroll        ; Only reachable if RAX is greater than 2000

    jmp hdp_shared_aputs

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

    shl dx, 8
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



hdp_shared_newline_cursor:
    mov ax, word [cursor_pos]
    cmp ax, 1920
    jb .no_scroll       ; cursor_pos < 1920 means not at last row
    jmp .scroll

.scroll:
    call hdp_shared_internal_scroll

    xor di, di
    mov si, 24
    call hdp_shared_reposition_cursor

    ret

.no_scroll:
    call hdp_shared_get_cursor_pos   ; AH=x, AL=y

    xor ah, ah        ; reset x = 0
    inc al            ; y++

    ; --- unpack row/col ---
    movzx di, ah      ; x = 0
    movzx si, al      ; y = row

    ; --- update cursor_pos ---
    mov ax, si
    imul ax, 80
    add ax, di
    mov [cursor_pos], ax

    ; --- reposition ---
    call hdp_shared_reposition_cursor
    ret
