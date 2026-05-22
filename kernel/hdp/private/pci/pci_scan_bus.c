#include "pci.h"

void hdp_pci_scan_device(uint8_t bus, uint8_t device);

void hdp_pci_scan_bus(void) {
    uint16_t bus = 0;
    uint8_t device = 0;

    while (bus < 256) {
        device = 0;

        while (device < 32) {
            hdp_pci_scan_device((uint8_t)bus, device);
            device++;
        }

        bus++;
    }
}