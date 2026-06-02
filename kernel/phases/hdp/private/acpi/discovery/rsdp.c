// RSDP things

// A header that tells where the "table of ptrs to other firmware tables (XSDT)" is.
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "shared/vgatb.h"
#include "shared/mem.h"

#define RSDP_SIGNATURE "RSD PTR "

static int checksum_valid(const struct hdp_acpi_rsdp_descriptor_t* const rsdp) {
    const uint8_t* bytes = (const uint8_t*)rsdp;

    // ACPI 1.0 checksum (first 20 bytes)
    uint32_t sum = 0;
    for (size_t i = 0; i < 20; i++)
        sum += bytes[i];

    if ((sum & 0xFF) != 0)
        return 0;

    // ACPI 2.0+ checksum (entire length)
    const _Bool has_extended_checksum = rsdp->revision >= 2 && rsdp->length >= 20 && rsdp->length <= sizeof(*rsdp);
    if (has_extended_checksum) {
        sum = 0;
        for (size_t i = 0; i < rsdp->length; i++)
            sum += bytes[i];

        if ((sum & 0xFF) != 0)
            return 0;
    }

    return 1;
}

/*const struct hdp_acpi_rsdp_descriptor_t* const hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end) {
    for (uintptr_t addr = start; addr < end; addr += 16) {

        const struct hdp_acpi_rsdp_descriptor_t* const rsdp = (struct hdp_acpi_rsdp_descriptor_t*)addr;

        if (shared_mem_cmp(rsdp->signature, RSDP_SIGNATURE, 8) != 0 || !checksum_valid(rsdp))
            continue;

        return rsdp;
    }
    return NULL;
}*/

const struct hdp_acpi_rsdp_descriptor_t* const hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end) {
    for (uintptr_t addr = start; addr < end; addr += 16) {

        uint8_t* p = (uint8_t*)addr;

        if (shared_mem_cmp(p, RSDP_SIGNATURE, 8) != 0)
            continue;

        struct hdp_acpi_rsdp_descriptor_t* rsdp =
            (struct hdp_acpi_rsdp_descriptor_t*)p;

        if (!checksum_valid(rsdp))
            continue;

        return rsdp;
    }

    return NULL;
}