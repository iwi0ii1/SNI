; Set CPU presets by giving in loaded addr of CPU fields (4 bytes)
; Note: doesn't switch mode instantly, only gives the possiblity of switching and preparing for it.

bits 16
global l16_cpu_set_preset

section .text
l16_cpu_set_preset:
    ; Yep

    ret