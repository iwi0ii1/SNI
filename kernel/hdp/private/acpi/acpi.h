// ACPI related shits. Shared with PCI
#pragma once

/// @brief Ptrs to other firmware tables
struct hdp_acpi_table_t {
    const struct hdp_acpi_xsdt_header* mcfg;
    const struct hdp_acpi_xsdt_header* madt;
    const struct hdp_acpi_xsdt_header* fadt;
    const struct hdp_acpi_xsdt_header* hpet;
};

/**
 * @brief Get ECAM base address
 */
extern uintptr_t hdp_acpi_get_ecam_base(void);