// ACPI table cachers (RSDT/XSDT variants)
#pragma once
#include "hwd/private/firmware/acpi/tables.h"

#include "shared/gcc_attr.h"
#include "shared/text.h"
#include "shared/mem.h"

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct k64_hwd_firmware_acpi_table_t k64_hwd_firmware_acpi_cache_tables_rsdt(const struct k64_hwd_firmware_acpi_rsdt_t* const rsdt);

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct k64_hwd_firmware_acpi_table_t k64_hwd_firmware_acpi_cache_tables_xsdt(const struct k64_hwd_firmware_acpi_xsdt_t* const xsdt);