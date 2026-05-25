#ifndef HDP_PCI_H
#define HDP_PCI_H

#include <stdint.h>

struct hdp_pci_device_t {
    uint8_t bus;
    uint8_t dev;
    uint8_t func;

    uint16_t vendor;
    uint16_t device;

    uint8_t class_code;
    uint8_t subclass;
};

extern uint64_t hdp_pci_ecam_base_address;

uint16_t hdp_pci_read16(const uint8_t, const uint8_t, const uint8_t, const uint16_t);
uint32_t hdp_pci_read32(const uint8_t, const uint8_t, const uint8_t, const uint16_t);

void hdp_pci_store_device(const struct hdp_pci_device_t* const);

struct hdp_pci_device_t* hdp_pci_allocate_device(void);

void hdp_pci_scan_device(const uint8_t bus, const uint8_t device);
void hdp_pci_scan_bus(void);
void hdp_pci_init(void);

#endif