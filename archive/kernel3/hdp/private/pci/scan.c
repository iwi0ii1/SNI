#include "phases/hdp/private/pci/scan.h"



static void scan_func(const uint8_t bus, const uint8_t device, const uint8_t function) {
    struct hdp_pci_device_t* dev = NULL;

    if (hdp_pci_read16(bus, device, function, 0x00) == 0xFFFF)
        return;

    dev = hdp_pci_next_device_slot();

    dev->bus = bus;
    dev->dev = device;
    dev->func = function;

    dev->vendor = hdp_pci_get_vendor16(bus, device, function);
    dev->device = hdp_pci_get_device16(bus, device, function);

    dev->class_code = hdp_pci_get_class8(bus, device, function, 0);
    dev->subclass = hdp_pci_get_class8(bus, device, function, 1);

    hdp_pci_store_device(dev);
}

void hdp_pci_scan_device(const uint8_t bus, const uint8_t device) {
    uint8_t function;

    scan_func(bus, device, 0);

    uint8_t header = hdp_pci_get_header8(bus, device, 0);

    if (header & 0x80) {
        for (function = 1; function < 8; function++)
            scan_func(bus, device, function);
    }
}



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