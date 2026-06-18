bits 16
global _start16
extern _start64

section .text._start16
_start16:
    ; Set VGA Graphics Mode 0x13
    mov ax, 0x13
    int 0x10

    ; Set ES to the VGA segment
    mov ax, 0xA000
    mov es, ax
    
    ; Clear DI to start at the top-left of the screen
    xor di, di

    mov al, 0x52
    
    ; Set CX to 64,000 (total pixels)
    mov cx, 64000
    
    rep stosb ; Fill memory automatically!

.hang:
    hlt
    jmp short .hang

; Pad 512 bytes since BIOS requires exactly 512 bytes (u can exceed, tho will be ignored afterward)
times 510-($-$$) db 0 

; The "Magic Number" that the BIOS looks for to confirm it's bootable
dw 0xaa55