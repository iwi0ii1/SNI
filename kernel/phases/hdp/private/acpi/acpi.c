// ACPI related shits. Implementing things inside `acpi.h`
#include "phases/hdp/private/acpi/acpi.h"
#include "shared/mem.h"

[[nodiscard]]
struct hdp_acpi_table_t hdp_acpi_cache_tables_rsdt(const struct hdp_acpi_rsdt_header_t* const rsdt) {
    struct hdp_acpi_table_t table = {0};

    const uint32_t entries = (rsdt->header.length - sizeof(struct hdp_acpi_sdt_header_t)) / 4;

    const uint32_t* const ptrs = (const uint32_t*)((const uint8_t*)rsdt + sizeof(struct hdp_acpi_sdt_header_t));

    for (uint32_t i = 0; i < entries; i++) {
        const struct hdp_acpi_sdt_header_t* hdr = (const struct hdp_acpi_sdt_header_t*)(uintptr_t)ptrs[i];

        if (!shared_mem_cmp(hdr->signature, "MCFG", 4))
            table.mcfg = hdr;
        else if (!shared_mem_cmp(hdr->signature, "APIC", 4))
            table.madt = hdr;
        else if (!shared_mem_cmp(hdr->signature, "FACP", 4))
            table.fadt = hdr;
        else if (!shared_mem_cmp(hdr->signature, "HPET", 4))
            table.hpet = hdr;
    }

    return table;
}

[[nodiscard]]
struct hdp_acpi_table_t hdp_acpi_cache_tables_xsdt(const struct hdp_acpi_xsdt_header_t* const xsdt) {
    struct hdp_acpi_table_t table = {0};

    const uint32_t entries = (xsdt->header.length - sizeof(struct hdp_acpi_sdt_header_t)) / 8;

    const uint64_t* ptrs = (const uint64_t*)((const uint8_t*)xsdt + sizeof(struct hdp_acpi_sdt_header_t));

    for (uint32_t i = 0; i < entries; i++) {
        const struct hdp_acpi_sdt_header_t* hdr = (const struct hdp_acpi_sdt_header_t*)ptrs[i];

        if (!shared_mem_cmp(hdr->signature, "MCFG", 4))
            table.mcfg = hdr;
        else if (!shared_mem_cmp(hdr->signature, "APIC", 4))
            table.madt = hdr;
        else if (!shared_mem_cmp(hdr->signature, "FACP", 4))
            table.fadt = hdr;
        else if (!shared_mem_cmp(hdr->signature, "HPET", 4))
            table.hpet = hdr;
    }

    return table;
}