#include "phases/hdp/api/acpi_table.h"
#include "phases/hdp/private/acpi/discovery/rsdp.h"
#include "phases/hdp/private/acpi/discovery/xsdt.h"

#include "shared/mem.h"
#include "shared/vgatb.h"

static struct hdp_acpi_table_t hdp_acpi_table = {0};

const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void) { return &hdp_acpi_table; }

/// @brief Print all fields of `hdp_acpi_rsdp_descriptor_t`
static void print_fields(const struct hdp_acpi_rsdp_descriptor_t* const rsdp) {
    unsigned char dest[65] = {0};

    shared_mem_u64_to_str(dest, rsdp->checksum, SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->extended_checksum, SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->length, SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_vgatb_aputs(rsdp->oem_id, 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->reserved[0], SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F); shared_vgatb_putc(',', 0x0F);  
    shared_mem_u64_to_str(dest, rsdp->reserved[1], SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F); shared_vgatb_putc(',', 0x0F);
    shared_mem_u64_to_str(dest, rsdp->reserved[2], SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F); shared_vgatb_putc(',', 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->revision, SHARED_MEM_DEC_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->rsdt_address, SHARED_MEM_HEX_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    
    shared_vgatb_newline_cursor(1);

    shared_mem_u64_to_str(dest, rsdp->xsdt_address, SHARED_MEM_HEX_TAG);
    shared_vgatb_aputs(dest, 0x0F);
    shared_vgatb_newline_cursor(1);

    while(1)
        __asm__("hlt");
}

void hdp_acpi_init(void) {
    const struct hdp_acpi_rsdp_descriptor_t* const rsdp = hdp_acpi_find_rsdp(0x0E0000, 0x100000);

    if (!rsdp) {
        shared_vgatb_aputs("rsdp is being NULL, again!!", 0x0F);
        while (1)
            __asm__("hlt");
    }

    if (rsdp->revision == 0 && rsdp->rsdt_address)
        hdp_acpi_cache_tables_rsdt(rsdp->rsdt_address);
    else
        hdp_acpi_cache_tables_xsdt(rsdp->xsdt_address);

    shared_vgatb_aputs("ACPI table contents:", 0x0F);
    shared_vgatb_newline_cursor(1);
    
    shared_vgatb_aputs(hdp_acpi_table.mcfg->signature, 0x0F);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.madt->signature, 0x0F);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.fadt->signature, 0x0F);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_aputs(hdp_acpi_table.hpet->signature, 0x0F);
    shared_vgatb_newline_cursor(1);
    shared_vgatb_newline_cursor(1);
}