#include "phases/hdp/api/acpi_table.h"
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "phases/hdp/private/acpi/acpi.h"

#include "shared/mem.h"
#include "shared/vgatb.h"

static struct hdp_acpi_table_t hdp_acpi_table = {0}; // Core ACPI table

const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void) { return &hdp_acpi_table; }



void hdp_acpi_init(void) {
    const struct hdp_acpi_rsdp_descriptor_t* const rsdp = hdp_acpi_find_rsdp(0x0E0000, 0x100000);

    #ifdef DEBUG_FORM
    if (!rsdp) {
        shared_vgatb_aputs("rsdp is being NULL, again!!", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    // Cache ACPI table by given SDT address (from RSDP)
    if (rsdp->revision == 0 && rsdp->rsdt_address) {
        shared_vgatb_aputs("Inside ACPI v1", 0x0F);
        shared_vgatb_newline_cursor(1);
        hdp_acpi_table = hdp_acpi_cache_tables_rsdt((struct hdp_acpi_rsdt_header_t*)(uintptr_t)rsdp->rsdt_address);
    } else if (rsdp->revision != 0 && rsdp->xsdt_address) {
        shared_vgatb_aputs("Inside ACPI v2+", 0x0F);
        shared_vgatb_newline_cursor(1);
        hdp_acpi_table = hdp_acpi_cache_tables_xsdt((struct hdp_acpi_xsdt_header_t*)rsdp->xsdt_address);
    } else { // For debugging purpose
        #ifdef DEBUG_FORM
        shared_vgatb_aputs("Neither inside ACPI v1 nor v2+... hdp_acpi_find_rsdp(0x0E0000, 0x100000) could've been wrong.", 0x0F);
        #endif
        while (1)
            __asm__("hlt");
    }

    if (shared_mem_cmp(hdp_acpi_table.madt->signature, "APIC", 4) == 0)
        shared_vgatb_aputs("shared_mem_cmp(hdp_acpi_table.madt->signature, \"APIC\", 4) == 0 is true...", 0x0F);
    else
        shared_vgatb_aputs("shared_mem_cmp(hdp_acpi_table.madt->signature, \"APIC\", 4) == 0 is false...", 0x0F);

    while (1)
        __asm__("hlt"); // Halted here to make sure acpi_init is correct
}