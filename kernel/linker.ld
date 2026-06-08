ENTRY(_start)

SECTIONS {
    /* Bootloader drops kernel at the 1MB physical boundary */
    . = 1M;

    /* 1. CODE: Must be at the front so the bootloader finds the header immediately */
    .text : ALIGN(4096) {
        KEEP(*(.multiboot_header))
        *(.text*)
    }

    /* 2. READ-ONLY DATA: Constants, strings */
    .rodata : ALIGN(4096) { 
        *(.rodata*) 
    }

    /* 3. INITIALIZED DATA: Global variables with preset values */
    .data : ALIGN(4096) { 
        *(.data*) 
    }

    /* 4. UNINITIALIZED DATA: Global variables initialized to zero */
    .bss : ALIGN(4096) { 
        *(.bss*) 
        *(COMMON) 
    }
}