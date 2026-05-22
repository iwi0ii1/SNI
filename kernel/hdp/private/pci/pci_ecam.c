#include "pci.h"

uint64_t hdp_pci_ecam_base_address = 0;

uint32_t hdp_pci_read32(uint8_t bus, uint8_t device, uint8_t function, uint16_t offset) {
    uint64_t address;

    address = hdp_pci_ecam_base_address +
        ((uint64_t)bus << 20) +
        ((uint64_t)device << 15) +
        ((uint64_t)function << 12) +
        offset;

    return *(volatile uint32_t *)address;
}

uint16_t hdp_pci_read16(uint8_t bus, uint8_t device, uint8_t function, uint16_t offset) {
    return (uint16_t)(hdp_pci_read32(bus, device, function, offset) & 0xFFFF);
}