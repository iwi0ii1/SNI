// Device storage related things.

#include "pci.h"

#define HDP_PCI_MAX_DEVICES 512

struct hdp_pci_device_t hdp_pci_device_list[HDP_PCI_MAX_DEVICES];
uint32_t hdp_pci_device_count = 0;

void hdp_pci_store_device(const struct hdp_pci_device_t* const device) {
    if (hdp_pci_device_count >= HDP_PCI_MAX_DEVICES)
        return;

    hdp_pci_device_list[hdp_pci_device_count] = *device;
    hdp_pci_device_count++;
}

struct hdp_pci_device_t* const hdp_pci_next_device_slot(void) {
    return &hdp_pci_device_list[hdp_pci_device_count];
}