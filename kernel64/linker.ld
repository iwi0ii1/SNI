ENTRY(k64_main)

SECTIONS {
    . = 0x200000;

    .kernel64 : {
        *(.kernel64)
        *(.text)
        *(.rodata)
        *(.data)
        *(.bss)
    }
}