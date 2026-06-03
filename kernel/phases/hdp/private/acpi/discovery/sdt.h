// XSDT things exposed through header

// XSDT is just a table of ptrs to other firmware tables (MCFG, MADT, FADT, SSDT, HPET, etc)

#pragma once

#include <stdint.h>
#include <stddef.h>

/**
 * @brief SDT header
 */
struct __attribute__((packed)) hdp_acpi_sdt_header_t { 
    char signature[4];
    uint32_t length;
    uint8_t revision;
    uint8_t checksum;
    char oem_id[6];
    char oem_table_id[8];
    uint32_t oem_revision;
    uint32_t creator_id;
    uint32_t creator_revision;
};



/// @brief RSDT header (v1)
struct __attribute__((packed)) hdp_acpi_rsdt_header_t {
    const struct hdp_acpi_sdt_header_t header;
    uint32_t entries[]; // array of 32-bit ptr to firmware tables
};


/// @brief XSDT header (v2+)
struct __attribute__((packed)) hdp_acpi_xsdt_header_t {
    const struct hdp_acpi_sdt_header_t header;
    uint64_t entries[]; // array of 64-bit ptr to firmware tables
};