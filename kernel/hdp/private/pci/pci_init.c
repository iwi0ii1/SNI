#include "pci.h"

extern void hdp_shared_aputs(char*, uint8_t);
extern void hdp_shared_newline_cursor(void);

void hdp_pci_init(void) {
    if (hdp_pci_ecam_base_address == 0)
        return;

    hdp_pci_scan_bus();
    
    for (uint16_t i = 0; i < 512; ++i) {
        const struct hdp_pci_device_t* const dev_slot = hdp_pci_get_device_slot(i);
        hdp_shared_aputs("", 0x0F);
        hdp_shared_newline_cursor();
    }
}