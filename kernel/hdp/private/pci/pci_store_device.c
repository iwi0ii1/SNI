#include "pci.h"

#define HDP_PCI_MAX_DEVICES 512

struct hdp_pci_device_t hdp_pci_device_list[HDP_PCI_MAX_DEVICES];
uint32_t hdp_pci_device_count = 0;

void hdp_pci_store_device(struct hdp_pci_device_t *device) {
    if (hdp_pci_device_count >= HDP_PCI_MAX_DEVICES)
        return;

    hdp_pci_device_list[hdp_pci_device_count] = *device;
    hdp_pci_device_count++;
}