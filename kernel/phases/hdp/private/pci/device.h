#pragma once

#include <stdint.h>
#include <stddef.h>

struct hdp_pci_device_t {
    uint8_t bus;
    uint8_t dev;
    uint8_t func;

    uint16_t vendor;
    uint16_t device;

    uint8_t class_code;
    uint8_t subclass;
};

extern void hdp_pci_store_device(const struct hdp_pci_device_t* const);   // Store what's found to the list, cuh

extern struct hdp_pci_device_t* const hdp_pci_next_device_slot(void);     // Get next device slot. Returns NULL if limit reached
extern const struct hdp_pci_device_t* const hdp_pci_get_device_slot(const uint16_t idx); // Get a device slot (0 based). Returns NULL if out-of-bounds.