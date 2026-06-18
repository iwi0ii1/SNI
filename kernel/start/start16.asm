bits 16
global _start16
extern _start64

section .text
_start16:
    ; Set VGA Graphics Mode 0x13
    mov ax, 0x13
    int 0x10

    mov ah, 0x0E
    mov al, 'A'

    int 0x10 ; BIOS Interrupts for video things

.hang:
    hlt
    jmp .hang