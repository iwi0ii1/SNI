// RSDP things

// A header that tells where the "table of ptrs to other firmware tables (XSDT)" is.
#include "rsdp.h"

#define RSDP_SIGNATURE "RSD PTR "

extern uint32_t hdp_shared_memcmp(void*, void*, size_t);

static int checksum_valid(const struct hdp_acpi_rsdp_descriptor_t* const rsdp) {
    const uint8_t* const bytes = (const uint8_t*)rsdp;

    // ACPI 1.0 checksum (first 20 bytes)
    uint8_t sum = 0;
    for (size_t i = 0; i < 20; i++)
        sum += bytes[i];

    if (sum != 0)
        return 0;

    // ACPI 2.0+ checksum (entire length, if length >= 20)
    if (rsdp->revision >= 2 && rsdp->length >= 20) {
        sum = 0;
        for (size_t i = 0; i < rsdp->length; i++)
            sum += bytes[i];

        if (sum != 0)
            return 0;
    }

    return 1; // valid
}

struct hdp_acpi_rsdp_descriptor_t* hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end) {
    for (uintptr_t addr = start; addr < end; addr += 16) {
        struct hdp_acpi_rsdp_descriptor_t* rsdp = (struct hdp_acpi_rsdp_descriptor_t*)addr;
        if (hdp_shared_memcmp(rsdp->signature, RSDP_SIGNATURE, 8) == 0) {
            if (checksum_valid(rsdp))
                return rsdp;
        }
    }
    return NULL;
}