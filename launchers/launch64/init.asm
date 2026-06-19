; Just cleaning up the shits from UEFI 64-bit transition. We can't assume CPU state is valid for us.
bits 64
global launch64

section .text.launch64
launch64:
    ; Yep