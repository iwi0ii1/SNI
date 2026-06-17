// ACPI related shits. Shared with PCI
#pragma once

#include "hwd/private/firmware/acpi/tables.h"


/// @brief Get ACPI table between domains (not part of API)
[[nodiscard]]
extern const struct hwd_firmware_acpi_table_t* const hwd_firmware_acpi_get_table(void);