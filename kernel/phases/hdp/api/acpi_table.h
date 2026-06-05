// Read ACPI table.
#pragma once

struct hdp_acpi_table_t;

/// @brief Get ACPI table
extern const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void);