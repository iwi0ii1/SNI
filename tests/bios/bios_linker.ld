OUTPUT_FORMAT("binary")
ENTRY(launch16)

SECTIONS {
    . = 0x7C00;

    .text : {
        *(.text.launch16)
        *(.text)
    }

    .rodata : { *(.rodata) }

    .data : { *(.data) }

    .bss : { *(.bss) }
}