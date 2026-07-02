// ACPI related shits. Shared with PCI
#pragma once

#include "hwd/firmware/acpi/tables.h"


/// @brief Get ACPI table between domains (not part of API)
[[nodiscard]]
extern const struct ks_hwd_firmwareAcpi_table_t* const ks_hwd_firmwareAcpi_getTable(void);