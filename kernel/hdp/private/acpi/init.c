#include "../../api/acpi_table.h"
#include "discovery/rsdp.h"
#include "discovery/xsdt.h"

static struct hdp_acpi_table_t hdp_acpi_table = {0};

const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void) { return &hdp_acpi_table; }

void hdp_acpi_init(void) {
    struct hdp_acpi_rsdp_descriptor_t* const rsdp = hdp_acpi_find_rsdp(0x000E0000, 0x00100000);
    if (!rsdp)
        return;

    hdp_acpi_table = hdp_acpi_cache_tables((struct hdp_acpi_xsdt_header_t*)rsdp->xsdt_address);
}