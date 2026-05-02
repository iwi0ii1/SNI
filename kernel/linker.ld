ENTRY(_start)

MEMORY {
    RAM (rwx) : ORIGIN = 1M, LENGTH = 512M
}

PHDRS {
    text PT_LOAD FLAGS(5);
}

SECTIONS {
    . = ORIGIN(RAM);

    .multiboot ALIGN(8) : {
        KEEP(*(.multiboot*))
    } :text

    .stack (NOLOAD) : {
        . = 0x00300000;   /* fixed safe address: 3MB */
        stack_bottom = .;
        . = . + 0x10000;  /* 64 KB stack */
        stack_top = .;
    }

    .text : {
        *(.text*)
    } :text

    .rodata : {
        *(.rodata*)
    } :text

    .data : {
        *(.data*)
    } :text

    .bss : {
        *(.bss*)
    } :text
}