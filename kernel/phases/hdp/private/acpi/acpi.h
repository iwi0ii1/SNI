// ACPI related shits. Shared with PCI
#pragma once

#include "phases/hdp/private/acpi/discovery/sdt.h"

/// @brief Table of ptrs to other firmware tables' SDT header
struct __attribute__((packed)) hdp_acpi_table_t {
    const struct hdp_acpi_sdt_header_t* mcfg;
    const struct hdp_acpi_sdt_header_t* madt;
    const struct hdp_acpi_sdt_header_t* fadt;
    const struct hdp_acpi_sdt_header_t* hpet;
};

/**
 * @brief Loop over given RSDT table and return a newly made ACPI table
 * @note Only valid in ACPI v1
 */
[[nodiscard]]
extern struct hdp_acpi_table_t hdp_acpi_cache_tables_rsdt(const struct hdp_acpi_rsdt_header_t* const rsdt);

/**
 * @brief Loop over given XSDT table and return a newly made ACPI table
 * @note Only valid in ACPI v2+
 */
[[nodiscard]]
extern struct hdp_acpi_table_t hdp_acpi_cache_tables_xsdt(const struct hdp_acpi_xsdt_header_t* const xsdt);

/**
 * @brief Get ECAM base address
 */
//extern uintptr_t hdp_acpi_get_ecam_base(void);

[[nodiscard]]
static inline uintptr_t hdp_acpi_get_ecam_base(void) {
    return 0; // Temporary only!!!
}