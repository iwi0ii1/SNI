// XSDT things
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "phases/hdp/private/acpi/discovery/sdt.h"

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