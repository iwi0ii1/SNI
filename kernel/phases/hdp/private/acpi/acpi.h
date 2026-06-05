// ACPI related shits. Shared with PCI
#pragma once

struct hdp_acpi_table_t;

/// @brief Get ACPI table between domains (not part of API)
extern const struct hdp_acpi_table_t* const hdp_acpi_get_table(void);