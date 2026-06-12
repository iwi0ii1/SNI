bits 32
global stack32_bottom
global stack32_top

section .bss
align 16
stack32_bottom:
resb 4096 * 8
stack32_top:



bits 64
global stack64_bottom
global stack64_top

section .bss
align 16
stack64_bottom:
resb 4096 * 8
stack64_top: