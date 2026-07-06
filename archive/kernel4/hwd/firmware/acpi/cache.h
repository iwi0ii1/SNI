// ACPI table cachers (RSDT/XSDT variants)
#pragma once
#include "hwd/firmware/acpi/tables.h"

#include "shared/gcc_attr.h"
#include "shared/mem.h"

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct ks_hwd_firmwareAcpi_table_t ks_hwd_firmwareAcpi_cacheTablesRsdt(const struct ks_hwd_firmwareAcpi_rsdt_t* const rsdt);

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct ks_hwd_firmwareAcpi_table_t ks_hwd_firmwareAcpi_cacheTablesXsdt(const struct ks_hwd_firmwareAcpi_xsdt_t* const xsdt);