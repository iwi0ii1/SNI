#include "../../api/acpi_table.h"
#include "discovery/rsdp.h"
#include "discovery/xsdt.h"

extern void hdp_shared_aputs(const char* const, const uint8_t);
extern void hdp_shared_newline_cursor(void);

extern uint32_t hdp_shared_memcmp(void*, void*, size_t);

static struct hdp_acpi_table_t hdp_acpi_table = {0};

const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void) { return &hdp_acpi_table; }

void hdp_acpi_init(void) {
    const struct hdp_acpi_rsdp_descriptor_t* const rsdp = hdp_acpi_find_rsdp(0x000E0000, 0x00100000);
    if (!rsdp) {
        hdp_shared_aputs("Somehow, in hdp/private/acpi/init.c, rsdp is being NULL", 0x0F);
        while (1)
            __asm__("hlt");

        return;
    }

    if (!rsdp->xsdt_address) {
        hdp_shared_aputs("Somehow, in hdp/private/acpi/init.c, rsdp->xsdt_address is being NULL", 0x0F);
        while (1)
            __asm__("hlt");

        return;
    }

    hdp_acpi_table = hdp_acpi_cache_tables((struct hdp_acpi_xsdt_header_t*)rsdp->xsdt_address);

    hdp_shared_aputs("ACPI table contents:", 20);
    hdp_shared_newline_cursor();
    
    hdp_shared_aputs(hdp_acpi_table.mcfg->signature, 4);
    hdp_shared_newline_cursor();
    hdp_shared_aputs(hdp_acpi_table.madt->signature, 4);
    hdp_shared_newline_cursor();
    hdp_shared_aputs(hdp_acpi_table.fadt->signature, 4);
    hdp_shared_newline_cursor();
    hdp_shared_aputs(hdp_acpi_table.hpet->signature, 4);
    hdp_shared_newline_cursor();
    hdp_shared_newline_cursor();
}