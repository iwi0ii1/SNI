ENTRY(l16_main)

SECTIONS {
    . = 0x7C00;

    .text : {
        *(.launch16)
        *(.text)
    }

    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}