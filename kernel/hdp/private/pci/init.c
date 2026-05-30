#include "pci.h"
#include "../acpi/acpi.h"


extern void hdp_shared_aputs(const char* const, const uint8_t);
extern void hdp_shared_newline_cursor(void);

/// @brief Unsigned to ASCII
static char* utoa(uint32_t v) {
    static char num_str[11]; // 4.2 billion only has 10 digits, and last one for null-terminator

    char* p = num_str;
    char* start = num_str;

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

    return num_str;
}

/// @brief Concatenate two strings (both must be null-terminated)
static char* strcat(char* dst, const char* src) {
    char* p = dst;

    while (*p) p++;        // find end of dst

    while (*src) {         // copy src
        *p++ = *src++;
    }

    *p = '\0';
    return dst;
}



void hdp_pci_init(void) {
    if (hdp_acpi_get_ecam_base() == 0) {
        hdp_shared_aputs("Well, hdp_pci_ecam_base_address is 0... can't scan buses without it.", 0x0F);
        while (1)
            __asm__("hlt");

        return;
    }

    hdp_pci_scan_bus();
    
    for (uint16_t i = 0; i < 512; ++i) {
        const struct hdp_pci_device_t* const dev_slot = hdp_pci_get_device_slot(i);

        hdp_shared_aputs(strcat("- Bus: ", utoa(dev_slot->bus)), 0x0F);
        hdp_shared_aputs(strcat(", Dev: ", utoa(dev_slot->dev)), 0x0F);
        hdp_shared_aputs(strcat(", Func: ", utoa(dev_slot->func)), 0x0F);
        hdp_shared_aputs(strcat(", Vendor: ", utoa(dev_slot->vendor)), 0x0F);
        //hdp_shared_aputs(strcat(", Dev"))

        hdp_shared_newline_cursor();
    }
}