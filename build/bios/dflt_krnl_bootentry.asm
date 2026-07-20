            section .rodata

            db "SNI.Kernel" ; Display name
            dd 0x00
            dw 0x00

            dd 2048 ; LBA Src

            dd KRNL_LBA_COUNT

            dd 0x100000

            dd 0x00
            dw 0x00
