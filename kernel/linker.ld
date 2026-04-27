ENTRY(_start)

PHDRS {
    text PT_LOAD FLAGS(5);
}

SECTIONS {
    . = 1M;

    .multiboot ALIGN(8) : {
        KEEP(*(.multiboot*))
    } :text

    .stack (NOLOAD) : {
        . = ALIGN(16);
        stack_bottom = .;
        . = . + 0x10000;
        stack_top = .;
    }

    PROVIDE(stack_top = stack_top);
    PROVIDE(stack_bottom = stack_bottom);

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