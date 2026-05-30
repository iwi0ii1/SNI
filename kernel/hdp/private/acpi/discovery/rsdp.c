// RSDP things

// A header that tells where the "table of ptrs to other firmware tables (XSDT)" is.
#include "rsdp.h"

extern uint32_t hdp_shared_memcmp(void*, void*, size_t);

struct hdp_acpi_rsdp_descriptor_t* hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end) {
    for (uint32_t addr = start; addr < end; addr += 16) {
        struct hdp_acpi_rsdp_descriptor_t* rsdp = (struct hdp_acpi_rsdp_descriptor_t*)addr;
        if (hdp_shared_memcmp(rsdp->signature, RSDP_SIGNATURE, 8) == 0) {
            if (checksum_valid(rsdp))
                return rsdp;
        }
    }
    return NULL;
}