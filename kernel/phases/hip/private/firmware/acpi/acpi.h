// ACPI related shits. Shared with PCI
#pragma once

#include "phases/hdp/private/acpi/tables.h"


/// @brief Get ACPI table between domains (not part of API)
[[nodiscard]]
extern const struct hdp_acpi_table_t* const hdp_acpi_get_table(void);