#include "phases/hip/private/firmware/acpi/discovery/rsdp.h"
#include "phases/hip/private/firmware/acpi/cache.h"

#include "phases/hip/private/firmware/acpi/acpi.h"

#include "shared/mem.h"
#include "shared/vgatb.h"

static struct hip_firmware_acpi_table_t hip_firmware_acpi_table = {0}; // Core ACPI table


void hip_firmware_acpi_init(void) {
    const struct hip_firmware_acpi_rsdp_descriptor_t* const rsdp = hip_firmware_acpi_find_rsdp(0x0E0000, 0x100000);

    #ifdef DEBUG_FORM
    if (!rsdp) {
        shared_vgatb_aputs("rsdp is being NULL, again!!", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    // Cache ACPI table by given SDT address (from RSDP)
    if (rsdp->revision == 0 && rsdp->rsdt_address) {
        shared_vgatb_aputs("Inside ACPI v1. ", 0x0F);
        hip_firmware_acpi_table = hip_firmware_acpi_cache_tables_rsdt((struct hip_firmware_acpi_rsdt_t*)(uintptr_t)rsdp->rsdt_address);
    } else if (rsdp->revision != 0 && rsdp->xsdt_address) {
        shared_vgatb_aputs("Inside ACPI v2+. ", 0x0F);
        hip_firmware_acpi_table = hip_firmware_acpi_cache_tables_xsdt((struct hip_firmware_acpi_xsdt_t*)rsdp->xsdt_address);
    } else { // For debugging purpose
        #ifdef DEBUG_FORM
        shared_vgatb_aputs("Neither inside ACPI v1 nor v2+... hip_firmware_acpi_find_rsdp(0x0E0000, 0x100000) could've been wrong.", 0x0F);
        #endif
        while (1)
            __asm__("hlt");
    }

    #ifdef DEBUG_FORM
    if (shared_mem_cmp(hip_firmware_acpi_table.madt->header.signature, "APIC", 4) != 0) {
        shared_vgatb_aputs("hip_firmware_acpi_table.madt->signature isn't \"APIC\"...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif
}