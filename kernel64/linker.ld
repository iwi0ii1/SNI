OUTPUT_FORMAT("binary")
ENTRY(k64_main)

SECTIONS {
    . = 0x200000;

    .kernel64 : {
        *(.kernel64)
        *(.text)
        *(.rodata)
        *(.data)
        
        /* Pad relative to 0x7C00 across ALL sections combined */
        . = 0x7C00 + 510;
        SHORT(0xAA55);
    }
}