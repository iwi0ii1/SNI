OUTPUT_FORMAT("binary") /* Raw binary, not ELF or PE */
ENTRY(_start16)

SECTIONS {
    . = 0x7C00;

    /* 1. CODE: Explicit ordering prevents 32-bit / 64-bit interleaving */
    .text : ALIGN(4096) { 
        *(.text._start16)
        *(.text)
    }

    /* 2. READ-ONLY DATA: Constants, strings */
    .rodata : ALIGN(4096) { *(.rodata) }

    /* 3. INITIALIZED DATA */
    .data : ALIGN(4096) { *(.data) }

    /* 4. UNINITIALIZED DATA */
    .bss : ALIGN(4096) { *(.bss) }
}