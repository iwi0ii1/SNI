// ACPI and Firmware tables
#pragma once
#include <stdint.h>
#include <stddef.h>

/// @brief SDT header
struct __attribute__((packed)) hdp_acpi_sdt_header_t { 
    char signature[4];
    uint32_t length;
    uint8_t revision;
    uint8_t checksum;
    char oem_id[6];
    char oem_table_id[8];
    uint32_t oem_revision;
    uint32_t creator_id;
    uint32_t creator_revision;
};



/// @brief RSDT firmware root table (v1)
struct __attribute__((packed)) hdp_acpi_rsdt_t {
    struct hdp_acpi_sdt_header_t header;
    uint32_t entries[]; // array of 32-bit ptr to other firmware tables
};

/// @brief XSDT firmware root table (v2+)
struct __attribute__((packed)) hdp_acpi_xsdt_t {
    struct hdp_acpi_sdt_header_t header;
    uint64_t entries[]; // array of 64-bit ptr to other firmware tables
};



// HPET table
struct __attribute__((packed)) hdp_acpi_hpet_t {
    struct hdp_acpi_sdt_header_t header;
    uint32_t event_block_id;
    struct {
        uint8_t address_space_id;
        uint8_t register_bit_width;
        uint8_t register_bit_offset;
        uint8_t reserved;
        uint64_t address;
    } base_address;
    uint8_t  hpet_number;
    uint16_t minimum_tick;
    uint8_t  page_protection;
};



// MCFG table
struct __attribute__((packed)) hdp_acpi_mcfg_entry_t {
    uint64_t base_address;
    uint16_t segment_group;
    uint8_t  start_bus;
    uint8_t  end_bus;
    uint32_t reserved;
};

struct __attribute__((packed)) hdp_acpi_mcfg_t {
    struct hdp_acpi_sdt_header_t header;
    uint64_t reserved;
    struct hdp_acpi_mcfg_entry_t entries[];
};



// MADT table
struct __attribute__((packed)) hdp_acpi_madt_t {
    struct hdp_acpi_sdt_header_t header;
    uint32_t lapic_address;
    uint32_t flags;
    uint8_t  entries[]; // variable-length subtables (APIC structures)
};



// FADT table (simplified core fields)
struct __attribute__((packed)) hdp_acpi_fadt_t {
    struct hdp_acpi_sdt_header_t header;
    uint32_t firmware_ctrl;
    uint32_t dsdt;
    uint8_t  reserved;
    uint8_t  preferred_pm_profile;
    uint16_t sci_int;
    uint32_t smi_cmd;
    uint8_t  acpi_enable;
    uint8_t  acpi_disable;
    uint8_t  s4bios_req;
    uint8_t  pstate_ctrl;
    uint32_t pm1a_evt_blk;
    uint32_t pm1b_evt_blk;
    uint32_t pm1a_cnt_blk;
    uint32_t pm1b_cnt_blk;
    uint32_t pm2_cnt_blk;
    uint32_t pm_tmr_blk;
    uint32_t gpe0_blk;
    uint32_t gpe1_blk;
    // ... (many more fields per ACPI spec, but this is the core layout)
};




/**
 * @brief Entire ACPI table
 */
struct __attribute__((packed)) hdp_acpi_table_t {
    const struct hdp_acpi_mcfg_t* mcfg;
    const struct hdp_acpi_madt_t* madt;
    const struct hdp_acpi_fadt_t* fadt;
    const struct hdp_acpi_hpet_t* hpet;
};