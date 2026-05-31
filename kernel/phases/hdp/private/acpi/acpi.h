// ACPI related shits. Shared with PCI
#pragma once

#include "phases/hdp/private/acpi/discovery/xsdt.h"

/// @brief Ptrs to other firmware tables
struct hdp_acpi_table_t {
    const struct hdp_acpi_xsdt_header_t* mcfg;
    const struct hdp_acpi_xsdt_header_t* madt;
    const struct hdp_acpi_xsdt_header_t* fadt;
    const struct hdp_acpi_xsdt_header_t* hpet;
};

/**
 * @brief Get ECAM base address
 */
//extern uintptr_t hdp_acpi_get_ecam_base(void);

static inline uintptr_t hdp_acpi_get_ecam_base(void) {
    return 0; // Temporary only!!!
}