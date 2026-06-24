ENTRY(l16_main)

SECTIONS {
    . = 0x7C00;

    .launch16 : {
        build/launch16.o(.launch16)
        build/launch16.o(.text)
        build/launch16.o(.rodata)
        build/launch16.o(.data)
        /* Cannot have .bss */
    }

    . = 1M;

    .kernel64 : {
        build/kernel64.o(.kernel64)
        build/kernel64.o(.text)
        build/kernel64.o(.rodata)
        build/kernel64.o(.data)
    }
}