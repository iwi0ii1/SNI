#include "phases/hdp/private/acpi/acpi.h"

#include "phases/hdp/private/pci/scan.h"

#include "shared/vgatb.h"
#include "shared/mem.h"

/// @brief Unsigned to ASCII
/// @return Length
uint8_t utoa(uint32_t v, char* buf) {
    char* p = buf;
    char* start = buf;

    do {
        *p++ = '0' + (v % 10);
        v /= 10;
    } while (v);

    *p = '\0';

    // reverse
    char* end = p - 1;
    while (start < end) {
        char tmp = *start;
        *start++ = *end;
        *end-- = tmp;
    }

    return p - buf;
}



void hdp_pci_init(void) {
    const uint64_t ba = hdp_acpi_get_table()->mcfg->entries->base_address;
    if (!ba) {
        shared_vgatb_aputs("Well, hdp_acpi_get_table()->mcfg->entries->base_address is NULL... can't scan buses with it.", 0x0F);
        while (1)
            __asm__("hlt");

        return;
    }

    hdp_pci_scan_bus();
    
    for (uint16_t i = 0; i < 512; ++i) {
        const struct hdp_pci_device_t* const dev_slot = hdp_pci_get_device_slot(i);

        char bus_str[128] = {0};
        char dev_str[128] = {0};
        char func_str[128] = {0};
        char vendor_str[128] = {0};

        // Dedicated 11-byte scratchpads for safe number conversions
        char num_buf[11];

        // 1. Build Bus String: Copy label, convert number to scratchpad, append scratchpad
        shared_mem_cat(bus_str, "- Bus: ", "");
        utoa(dev_slot->bus, num_buf);
        shared_mem_cat(bus_str + 7, num_buf, "");

        char b_num[11], d_num[11], f_num[11], v_num[11];
        utoa(dev_slot->bus, b_num);
        utoa(dev_slot->dev, d_num);
        utoa(dev_slot->func, f_num);
        utoa(dev_slot->vendor, v_num);

        shared_mem_cat(bus_str, "- Bus: ", b_num);
        shared_mem_cat(dev_str, ", Dev: ", d_num);
        shared_mem_cat(func_str, ", Func: ", f_num);
        shared_mem_cat(vendor_str, ", Vendor: ", v_num);

        // Print to VGA
        shared_vgatb_aputs(bus_str, 0x0F);
        shared_vgatb_aputs(dev_str, 0x0F);
        shared_vgatb_aputs(func_str, 0x0F);
        shared_vgatb_aputs(vendor_str, 0x0F);

        shared_vgatb_newline_cursor(1);
    }
}