bits 64
global hdp_init

extern hdp_pci_init
extern hdp_acpi_init

section .text
hdp_init:
    call hdp_pci_init
    call hdp_acpi_init

    ret