// Reading 

#include "pci.h"
#include "../acpi/acpi.h"

uint32_t hdp_pci_read32(const uint8_t bus, const uint8_t device, const uint8_t function, const uint16_t offset) {
    uint64_t address;

    address = hdp_acpi_get_ecam_base() +
        ((uint64_t)bus << 20) +
        ((uint64_t)device << 15) +
        ((uint64_t)function << 12) +
        offset;

    return *(volatile uint32_t *)address;
}

uint16_t hdp_pci_read16(const uint8_t bus, const uint8_t device, const uint8_t function, const uint16_t offset) {
    return (uint16_t)(hdp_pci_read32(bus, device, function, offset) & 0xFFFF);
}

uint8_t hdp_pci_read8(uint8_t bus, uint8_t dev, uint8_t func, uint16_t offset) {
    uint32_t val = hdp_pci_read32(bus, dev, func, offset & ~3);
    return (val >> ((offset & 3) * 8)) & 0xFF;      // Some real complex bitops here...
}