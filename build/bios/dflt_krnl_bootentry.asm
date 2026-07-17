            section .rodata
            dq "SNI.Kernel" ; Display name
            dq 0x00
            dd 2048 ; LBA Src
            dd KRNL_LBA_COUNT
            dq 0x100000
            dw 0x00
