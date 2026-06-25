/* For l16_main, not l16_mbr */

OUTPUT_FORMAT("binary")
ENTRY(l16_main)

SECTIONS {
    . = 0x7E00;

    .load16 : {
        *(.l16_main)
        *(.text)
        *(.rodata)
        *(.data)
    }
}