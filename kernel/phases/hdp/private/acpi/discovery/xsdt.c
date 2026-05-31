// XSDT things
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "phases/hdp/private/acpi/discovery/xsdt.h"

#include "shared/mem.h"

void* hdp_acpi_find_table(const struct hdp_acpi_xsdt_header_t* const xsdt, const char* const signature) {
    const int entries_count = (xsdt->length - sizeof(struct hdp_acpi_xsdt_header_t)) / 8;
    const uintptr_t* const table_ptrs = (uintptr_t*)((uint8_t*)xsdt + sizeof(struct hdp_acpi_xsdt_header_t));

    for (int i = 0; i < entries_count; i++) {
        struct hdp_acpi_xsdt_header_t* hdr = (struct hdp_acpi_xsdt_header_t*)table_ptrs[i];
        if (shared_mem_cmp(hdr->signature, signature, 4) == 0)
            return hdr;
    }
    return NULL;
}

struct hdp_acpi_table_t hdp_acpi_cache_tables(const struct hdp_acpi_xsdt_header_t* const xsdt) {
    const int entries_count = (xsdt->length - sizeof(struct hdp_acpi_xsdt_header_t)) / 8;
    const uintptr_t* const table_ptrs = (uintptr_t*)((uint8_t*)xsdt + sizeof(struct hdp_acpi_xsdt_header_t));

    struct hdp_acpi_table_t tmp_acpi_table = {0}; // Temporary ACPI table that will be returned later

    for (int i = 0; i < entries_count; i++) {
        struct hdp_acpi_xsdt_header_t* hdr = (struct hdp_acpi_xsdt_header_t*)table_ptrs[i];
        if (shared_mem_cmp(hdr->signature, "MCFG", 4) == 0)
            tmp_acpi_table.mcfg = hdr;
        else if (shared_mem_cmp(hdr->signature, "APIC", 4) == 0)
            tmp_acpi_table.madt = hdr;
        else if (shared_mem_cmp(hdr->signature, "FACP", 4) == 0)
            tmp_acpi_table.fadt = hdr;
        else if (shared_mem_cmp(hdr->signature, "HPET", 4) == 0)
            tmp_acpi_table.hpet = hdr;
    }

    return tmp_acpi_table;
}