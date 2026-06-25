OUTPUT_FORMAT("binary")
ENTRY(l16_main)

SECTIONS {
    . = 0x7C00;

    .load16 : {
        *(.l16_mbr)
        *(.l16_main)
        *(.text)
        *(.rodata)
        *(.data)
    }
}