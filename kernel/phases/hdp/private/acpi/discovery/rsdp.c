// RSDP things

// A header that tells where the "table of ptrs to other firmware tables (XSDT)" is.
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "shared/vgatb.h"
#include "shared/mem.h"

#define RSDP_SIGNATURE "RSD PTR "

static _Bool checksum_valid(const uint8_t* const data, const size_t len) {
    uint8_t sum = 0;

    for (size_t i = 0; i < len; i++)
        sum += data[i];

    return sum == 0;
}

const struct hdp_acpi_rsdp_descriptor_t* const hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end) {
    for (uintptr_t addr = start; addr < end; addr += 16) {

        const uint8_t* const p = (uint8_t*)addr;

        if (shared_mem_cmp(p, RSDP_SIGNATURE, 8) != 0)
            continue;

        if (!checksum_valid(p, 20))
            continue;

        const struct hdp_acpi_rsdp_descriptor_t* const rsdp = (struct hdp_acpi_rsdp_descriptor_t*)p;

        return rsdp;
    }

    return NULL;
}