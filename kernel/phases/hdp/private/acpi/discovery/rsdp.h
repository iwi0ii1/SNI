// File with RSDP related things.
#pragma once

#include <stdint.h>
#include <stddef.h>

#include "shared/gcc_attr.h"

/// @brief RSDP descriptor type (v2+)
struct ATTR_PACKED hdp_acpi_rsdp_descriptor_t {
    char signature[8];
    uint8_t checksum;
    char oem_id[6];
    uint8_t revision;
    uint32_t rsdt_address;

    // ACPI v2+ things
    uint32_t length;
    uint64_t xsdt_address;
    uint8_t extended_checksum;
    uint8_t reserved[3];
};

/**
 * @brief Find a valid RSDP
 * @warning Returns NULL if failed to find a valid ones
 */
[[nodiscard]]
const struct hdp_acpi_rsdp_descriptor_t* const hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end);