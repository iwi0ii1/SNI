#include "phases/hip/private/firmware/acpi/cache.h"



[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
struct hip_firmware_acpi_table_t hip_firmware_acpi_cache_tables_rsdt(const struct hip_firmware_acpi_rsdt_t* const rsdt) {    
    #ifdef DEBUG_FORM
    if (!rsdt) {
        shared_vgatb_aputs("hip_firmware_acpi_cache_tables_rsdt: parameter (rsdt) is passed as NULL, type const struct hip_firmware_acpi_rsdt_header_t* const...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif
    
    struct hip_firmware_acpi_table_t table = {0};

    const uint32_t entries = (rsdt->header.length - sizeof(struct hip_firmware_acpi_sdt_header_t)) / 4;
    const uint32_t* const ptrs = (const uint32_t*)((const uint8_t*)rsdt + sizeof(struct hip_firmware_acpi_sdt_header_t));

    for (uint32_t i = 0; i < entries; i++) {
        const struct hip_firmware_acpi_sdt_header_t* const hdr = (const struct hip_firmware_acpi_sdt_header_t*)(uintptr_t)ptrs[i];

        if (!shared_mem_cmp(hdr->signature, "MCFG", 4))
            table.mcfg = (struct hip_firmware_acpi_mcfg_t*)(uintptr_t)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "APIC", 4))
            table.madt = (struct hip_firmware_acpi_madt_t*)(uintptr_t)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "FACP", 4))
            table.fadt = (struct hip_firmware_acpi_fadt_t*)(uintptr_t)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "HPET", 4))
            table.hpet = (struct hip_firmware_acpi_hpet_t*)(uintptr_t)ptrs[i];
    }

    return table;
}

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
struct hip_firmware_acpi_table_t hip_firmware_acpi_cache_tables_xsdt(const struct hip_firmware_acpi_xsdt_t* const xsdt) {
    #ifdef DEBUG_FORM
    if (!xsdt) {
        shared_vgatb_aputs("hip_firmware_acpi_cache_tables_xsdt: parameter (xsdt) is passed as NULL, type const struct hip_firmware_acpi_xsdt_header_t* const...", 0x0F);
        while (1)
            __asm__("hlt");
    }
    #endif

    const uint64_t entries = (xsdt->header.length - sizeof(struct hip_firmware_acpi_sdt_header_t)) / 8;
    const uint64_t* ptrs = (const uint64_t*)((const uint8_t*)xsdt + sizeof(struct hip_firmware_acpi_sdt_header_t));

    struct hip_firmware_acpi_table_t table = {0};

    for (uint32_t i = 0; i < entries; i++) {
        const struct hip_firmware_acpi_sdt_header_t* hdr = (const struct hip_firmware_acpi_sdt_header_t*)ptrs[i];

        if (!shared_mem_cmp(hdr->signature, "MCFG", 4))
            table.mcfg = (struct hip_firmware_acpi_mcfg_t*)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "APIC", 4))
            table.madt = (struct hip_firmware_acpi_madt_t*)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "FACP", 4))
            table.fadt = (struct hip_firmware_acpi_fadt_t*)ptrs[i];
        else if (!shared_mem_cmp(hdr->signature, "HPET", 4))
            table.hpet = (struct hip_firmware_acpi_hpet_t*)ptrs[i];
    }

    return table;
}