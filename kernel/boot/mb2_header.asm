section .multiboot
align 8

MB2_MAGIC    equ 0xE85250D6
MB2_ARCH     equ 0          ; i386 (works for long mode entry too)
MB2_LENGTH   equ mb2_end - mb2_start
MB2_CHECKSUM equ -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

mb2_start:
    dd MB2_MAGIC
    dd MB2_ARCH
    dd MB2_LENGTH
    dd MB2_CHECKSUM

    ; end tag
    dw 0
    dw 0
    dd 8

mb2_end: