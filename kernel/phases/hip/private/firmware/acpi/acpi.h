// ACPI related shits. Shared with PCI
#pragma once

#include "phases/hip/private/firmware/acpi/tables.h"


/// @brief Get ACPI table between domains (not part of API)
[[nodiscard]]
extern const struct hip_firmware_acpi_table_t* const hip_firmware_acpi_get_table(void);