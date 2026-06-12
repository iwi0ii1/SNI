ENTRY(_start)

SECTIONS {
    /* Bootloader drops kernel at the 1MB physical boundary */
    . = 1M;

    /* 1. CODE: Explicit ordering prevents 32-bit / 64-bit interleaving */
    .text : ALIGN(4096) {
        KEEP(*(.multiboot_header))
        
        /* Force the 32-bit entry code to sit exactly at the front */
        KEEP(*(.text.boot))
        
        /* All other 64-bit kernel code files fall safely behind it */
        *(.text*)
    }

    /* 2. READ-ONLY DATA: Constants, strings */
    .rodata : ALIGN(4096) { 
        *(.rodata*) 
    }

    /* 3. INITIALIZED DATA */
    .data : ALIGN(4096) { 
        *(.data*) 
    }

    /* 4. UNINITIALIZED DATA */
    .bss : ALIGN(4096) { 
        *(.bss*) 
        *(COMMON) 
    }
}