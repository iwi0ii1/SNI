ENTRY(ks_main)

SECTIONS {
    . = 0x200000;

    .kernel : {
        *(.kernel)
        *(.text)
        *(.rodata)
        *(.data)
        *(.bss)
    }
}