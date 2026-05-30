// XSDT things exposed through header

// XSDT is just a table of ptrs to other firmware tables (MCFG, MADT, FADT, SSDT, HPET, etc)

#pragma once

#include "../acpi.h"
#include <stdint.h>
#include <stddef.h>

/// @brief XSDT header
struct hdp_acpi_xsdt_header_t {
    char signature[4];       // "XSDT"
    uint32_t length;         // total length of the table
    uint8_t revision;
    uint8_t checksum;
    char oem_id[6];
    char oem_table_id[8];
    uint32_t oem_revision;
    uint32_t creator_id;
    uint32_t creator_revision;

    uintptr_t entries[];      // flexible array of table addresses
};

/**
 * @brief Find a firmware table (like MCFG, MADT, FADT, etc)
 * @warning Returns NULL if failed to find valid ones
 */
extern void* hdp_acpi_find_table(const struct hdp_acpi_xsdt_header_t* const xsdt, const char* const signature);

/**
 * @brief Loop over given XSDT table and return a newly made ACPI table
 */
extern struct hdp_acpi_table_t hdp_acpi_cache_tables(const struct hdp_acpi_xsdt_header_t* const xsdt);