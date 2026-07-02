#include "hwd/firmware/acpi/discovery/rsdp.h"
#include "hwd/firmware/acpi/cache.h"

#include "hwd/firmware/acpi/acpi.h"

#include "shared/mem.h"
#include "shared/text.h"

static struct ks_hwd_firmwareAcpi_table_t ks_hwd_firmwareAcpi_table = {0}; // Core ACPI table
const struct ks_hwd_firmwareAcpi_table_t* const ks_hwd_firmwareAcpi_getTable(void) { return &ks_hwd_firmwareAcpi_table; }

void ks_hwd_firmwareAcpi_init(void) {
    const struct ks_hwd_firmwareAcpi_rsdpDescriptor_t* const rsdp = ks_hwd_firmwareAcpi_find_rsdp(0x0E0000, 0x100000);

    #ifdef DEBUG_FORM
    if (!rsdp) {
        ks_shared_textAputs("rsdp is being NULL, again!!", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    // Cache ACPI table by given SDT address (from RSDP)
    if (rsdp->revision == 0 && rsdp->rsdt_address) {
        ks_shared_textAputs("Inside ACPI v1. ", 0x0F);
        ks_hwd_firmwareAcpi_table = ks_hwd_firmwareAcpi_cacheTablesRsdt((struct ks_hwd_firmwareAcpi_rsdt_t*)(uintptr_t)rsdp->rsdt_address);
    } else if (rsdp->revision != 0 && rsdp->xsdt_address) {
        ks_shared_textAputs("Inside ACPI v2+. ", 0x0F);
        ks_hwd_firmwareAcpi_table = ks_hwd_firmwareAcpi_cacheTablesXsdt((struct ks_hwd_firmwareAcpi_xsdt_t*)rsdp->xsdt_address);
    } else { // For debugging purpose
        #ifdef DEBUG_FORM
        ks_shared_textAputs("Neither inside ACPI v1 nor v2+... ks_hwd_firmwareAcpi_find_rsdp(0x0E0000, 0x100000) could've been wrong.", 0x0F);
        #endif
        while (1)
            __asm__("hlt");
    }

    #ifdef DEBUG_FORM
    if (ks_shared_memcmp(ks_hwd_firmwareAcpi_table.madt->header.signature, "APIC", 4) != 0) {
        ks_shared_textAputs("ks_hwd_firmwareAcpi_table.madt->signature isn't \"APIC\"...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif
}