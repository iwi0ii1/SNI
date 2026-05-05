ENTRY(_start)

SECTIONS {
    . = 1M;

    .stack (NOLOAD) : ALIGN(16) {
        stack_bottom = .;
        . = . + 0x8000;
        stack_top = .;
    }

    .text : {
        KEEP(*(.multiboot_header))
        *(.text*)
    }

    .rodata : { *(.rodata*) }
    .data   : { *(.data*) }
    .bss    : { *(.bss*) *(COMMON) }
}