            section .rodata
            db "SNI.Kernel (x64)" ; Display name
            dd 2048               ; Start LBA
            dd KRNL_SECTORS_COUNT ; Sectors count
            dd 1024 * 1024        ; Load dest
            dd 0x00               ; Extra
            dw 0x00               ; Extra

            times 512 - 34 - 2 db 0x00 ; Zero out between entries and settings

            db 1 ; Primary boot option
            db 0 ; Secondary boot option
