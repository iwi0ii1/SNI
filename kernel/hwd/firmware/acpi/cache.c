#include "hwd/firmware/acpi/cache.h"



[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
struct ks_hwd_firmwareAcpi_table_t ks_hwd_firmwareAcpi_cacheTablesRsdt(const struct ks_hwd_firmwareAcpi_rsdt_t* const rsdt) {
    #ifdef DEBUG_FORM
    if (!rsdt) {
        ks_shared_textAputs("ks_hwd_firmwareAcpi_cache_tables_rsdt: parameter (rsdt) is passed as NULL, type const struct ks_hwd_firmwareAcpi_rsdt_header_t* const...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    struct ks_hwd_firmwareAcpi_table_t table = {0};

    const uint32_t entries = (rsdt->header.length - sizeof(struct ks_hwd_firmwareAcpi_sdtHeader_t)) / 4;
    const uint32_t* const ptrs = (const uint32_t*)((const uint8_t*)rsdt + sizeof(struct ks_hwd_firmwareAcpi_sdtHeader_t));

    for (uint32_t i = 0; i < entries; i++) {
        const struct ks_hwd_firmwareAcpi_sdtHeader_t* const hdr = (const struct ks_hwd_firmwareAcpi_sdtHeader_t*)(uintptr_t)ptrs[i];

        if (!ks_shared_memcmp(hdr->signature, "MCFG", 4))
            table.mcfg = (struct ks_hwd_firmwareAcpi_mcfg_t*)(uintptr_t)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "APIC", 4))
            table.madt = (struct ks_hwd_firmwareAcpi_madt_t*)(uintptr_t)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "FACP", 4))
            table.fadt = (struct ks_hwd_firmwareAcpi_fadt_t*)(uintptr_t)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "HPET", 4))
            table.hpet = (struct ks_hwd_firmwareAcpi_hpet_t*)(uintptr_t)ptrs[i];
    }

    return table;
}

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
struct ks_hwd_firmwareAcpi_table_t ks_hwd_firmwareAcpi_cacheTablesXsdt(const struct ks_hwd_firmwareAcpi_xsdt_t* const xsdt) {
    #ifdef DEBUG_FORM
    if (!xsdt) {
        ks_shared_textAputs("ks_hwd_firmwareAcpi_cache_tables_xsdt: parameter (xsdt) is passed as NULL, type const struct ks_hwd_firmwareAcpi_xsdt_header_t* const...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    const uint64_t entries = (xsdt->header.length - sizeof(struct ks_hwd_firmwareAcpi_sdtHeader_t)) / 8;
    const uint64_t* ptrs = (const uint64_t*)((const uint8_t*)xsdt + sizeof(struct ks_hwd_firmwareAcpi_sdtHeader_t));

    struct ks_hwd_firmwareAcpi_table_t table = {0};

    for (uint32_t i = 0; i < entries; i++) {
        const struct ks_hwd_firmwareAcpi_sdtHeader_t* hdr = (const struct ks_hwd_firmwareAcpi_sdtHeader_t*)ptrs[i];

        if (!ks_shared_memcmp(hdr->signature, "MCFG", 4))
            table.mcfg = (struct ks_hwd_firmwareAcpi_mcfg_t*)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "APIC", 4))
            table.madt = (struct ks_hwd_firmwareAcpi_madt_t*)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "FACP", 4))
            table.fadt = (struct ks_hwd_firmwareAcpi_fadt_t*)ptrs[i];
        else if (!ks_shared_memcmp(hdr->signature, "HPET", 4))
            table.hpet = (struct ks_hwd_firmwareAcpi_hpet_t*)ptrs[i];
    }

    return table;
}