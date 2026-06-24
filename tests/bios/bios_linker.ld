ENTRY(l16_main)

SECTIONS {
    . = 0x7C00;

    .launch16 : { *(.launch16) } = 0x7C00
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    /* Cannot have .bss */
}