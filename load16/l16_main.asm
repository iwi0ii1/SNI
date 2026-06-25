bits 16
global l16_main

section .l16_main
l16_main:
    ; load16 entrypoint

.hang:
    cli
    hlt
    jmp .hang