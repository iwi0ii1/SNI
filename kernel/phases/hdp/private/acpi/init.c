#include "phases/hdp/api/acpi_table.h"
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "phases/hdp/private/acpi/discovery/xsdt.h"

#include "shared/mem.h"
#include "shared/vgatb.h"

static struct hdp_acpi_table_t hdp_acpi_table = {0};

const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void) { return &hdp_acpi_table; }

void hdp_acpi_init(void) {
    shared_vgatb_aputs("Entering hdp_acpi_init.", 0x0F);

    const struct hdp_acpi_rsdp_descriptor_t* const rsdp = hdp_acpi_find_rsdp(0x000E0000, 0x00100000);
    if (!rsdp) {
        shared_vgatb_aputs("Somehow, in hdp/private/acpi/init.c, rsdp is being NULL", 0x0F);
        while (1)
            __asm__("hlt");
    }

    if (!rsdp->xsdt_address) {
        shared_vgatb_aputs("Somehow, in hdp/private/acpi/init.c, rsdp->xsdt_address is being NULL", 0x0F);
        while (1)
            __asm__("hlt");
    }

    hdp_acpi_table = hdp_acpi_cache_tables((struct hdp_acpi_xsdt_header_t*)rsdp->xsdt_address);

    shared_vgatb_aputs("ACPI table contents:", 20);
    shared_vgatb_newline_cursor(1);
    
    shared_vgatb_aputs(hdp_acpi_table.mcfg->signature, 4);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.madt->signature, 4);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.fadt->signature, 4);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.hpet->signature, 4);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_newline_cursor(1);
}