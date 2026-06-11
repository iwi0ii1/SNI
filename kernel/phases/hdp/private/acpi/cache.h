// ACPI table cachers (RSDT/XSDT variants)
#pragma once
#include "phases/hdp/private/acpi/tables.h"

#include "shared/gcc_attr.h"
#include "shared/vgatb.h"
#include "shared/mem.h"

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct hdp_acpi_table_t hdp_acpi_cache_tables_rsdt(const struct hdp_acpi_rsdt_t* const rsdt);

[[nodiscard]]
ATTR_NO_SSE // Don't use SSE or MMX for this function
extern struct hdp_acpi_table_t hdp_acpi_cache_tables_xsdt(const struct hdp_acpi_xsdt_t* const xsdt);