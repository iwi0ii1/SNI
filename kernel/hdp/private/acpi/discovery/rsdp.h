// File with RSDP related things.
#pragma once

#include <stdint.h>
#include <stddef.h>

/// @brief RSDP descriptor type (v2+)
struct hdp_acpi_rsdp_descriptor_t {
    char signature[8];
    uint8_t checksum;
    char oem_id[6];
    uint8_t revision;
    uint32_t rsdt_address;
    uint32_t length;
    uintptr_t xsdt_address;
    uint8_t extended_checksum;
    uint8_t reserved[3];
} __attribute__((packed));

/**
 * @brief Find a valid RSDP
 * @warning Returns NULL if failed to find a valid ones
 */
extern struct hdp_acpi_rsdp_descriptor_t* hdp_acpi_find_rsdp(const uint32_t start, const uint32_t end);