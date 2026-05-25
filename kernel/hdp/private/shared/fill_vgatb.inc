; HDP's VGATB filler, include this directly, not extern it.
; Parameter: DIL for color attribute

bits 64

section .text
fill_vgatb:
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