bits 32
extern ecp_gdt_init ; 32-bit GDT init
extern ecp_paging_init ; 32-bit Paging init

bits 64
extern ecp_idt_init ; 64-bit IDT init