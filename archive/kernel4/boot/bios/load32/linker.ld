ENTRY(l32_main)

SECTIONS {
    . = 0x7E00;

    .load32 : {
        *(.l32_main)
        *(.text)
        *(.rodata)
        *(.data)
    }
}