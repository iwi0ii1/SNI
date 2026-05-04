section .multiboot_header
align 8
header_start:
    dd 0xe85250d6                ; Magic
    dd 0                         ; Architecture 0 (i386 protected)
    dd header_end - header_start ; Header length
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; --- FRAMEBUFFER TAG ---
    align 8
    dw 5    ; Type 5
    dw 0    ; Flags
    dd 20   ; Size
    dd 1024 ; Width
    dd 768  ; Height
    dd 32   ; Depth

    ; --- END TAG ---
    align 8
    dw 0    ; Type 0
    dw 0    ; Flags
    dd 8    ; Size
header_end: