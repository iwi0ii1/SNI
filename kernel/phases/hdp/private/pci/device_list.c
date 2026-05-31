// Device storage related things.

#include "phases/hdp/private/pci/pci.h"

#define HDP_PCI_MAX_DEVICES 512

static struct hdp_pci_device_t hdp_pci_device_list[HDP_PCI_MAX_DEVICES]; // Internal devices list
static uint16_t hdp_pci_device_count = 0; // Devices counter

void hdp_pci_store_device(const struct hdp_pci_device_t* const device) {
    if (hdp_pci_device_count >= HDP_PCI_MAX_DEVICES)
        return;

    hdp_pci_device_list[hdp_pci_device_count] = *device;
    hdp_pci_device_count++;
}

struct hdp_pci_device_t* const hdp_pci_next_device_slot(void) {
    if (hdp_pci_device_count >= HDP_PCI_MAX_DEVICES)
        return NULL;

    return hdp_pci_device_list + hdp_pci_device_count;
}

const struct hdp_pci_device_t* const hdp_pci_get_device_slot(const uint16_t idx) {
    if (idx >= hdp_pci_device_count)
        return NULL;

    return hdp_pci_device_list + hdp_pci_device_count;
}