// RSDP things

// A header that tells where the "table of ptrs to other firmware tables (XSDT)" is.
#include "hwd/firmware/acpi/discovery/rsdp.h"
#include "shared/mem.h"

#define RSDP_SIGNATURE "RSD PTR "

static _Bool checksum_valid(const uint8_t* const data, const size_t len) {
    uint8_t sum = 0;

    for (size_t i = 0; i < len; i++)
        sum += data[i];

    return sum == 0;
}

[[nodiscard]]
const struct ks_hwd_firmwareAcpi_rsdpDescriptor_t* const ks_hwd_firmwareAcpi_findRsdp(const uint32_t start, const uint32_t end) {
    for (uintptr_t addr = start; addr < end; addr += 16) {
        const uint8_t* const p = (uint8_t*)addr;

        if (ks_shared_memcmp(p, RSDP_SIGNATURE, 8) != 0)
            continue;

        const struct ks_hwd_firmwareAcpi_rsdpDescriptor_t* const rsdp = (struct ks_hwd_firmwareAcpi_rsdpDescriptor_t*)p;

        if (rsdp->revision == 0) {
            if (!checksum_valid(p, 20))
                continue;
        } else {
            if (!checksum_valid(p, rsdp->length))
                continue;
        }

        return rsdp;
    }

    return NULL;
}