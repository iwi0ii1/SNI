; Init in interface phase is weird, but this init is for initailizing internal states
bits 64
global hip_init

section .text
hip_init:
    ; Firmware -> Buses -> Memory -> Storage -> Display -> Timer -> Input -> Audio -> Network
    

    ret