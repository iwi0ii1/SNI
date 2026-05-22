#include "pci.h"

void hdp_pci_scan_bus(void);

void hdp_pci_init(void) {
    if (hdp_pci_ecam_base_address == 0)
        return;

    hdp_pci_scan_bus();
}