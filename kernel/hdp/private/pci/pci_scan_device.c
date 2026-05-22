#include "pci.h"

static void scan_func(uint8_t bus, uint8_t device, uint8_t function) {
    struct hdp_pci_device_t *dev;
    uint32_t classreg;

    if (hdp_pci_read16(bus, device, function, 0x00) == 0xFFFF)
        return;

    dev = hdp_pci_allocate_device();

    dev->bus = bus;
    dev->dev = device;
    dev->func = function;

    dev->vendor = hdp_pci_read16(bus, device, function, 0x00);
    dev->device = hdp_pci_read16(bus, device, function, 0x02);

    classreg = hdp_pci_read32(bus, device, function, 0x08);

    dev->class_code = (classreg >> 24) & 0xFF;
    dev->subclass = (classreg >> 16) & 0xFF;

    hdp_pci_store_device(dev);
}

void hdp_pci_scan_device(uint8_t bus, uint8_t device) {
    uint8_t function;

    scan_func(bus, device, 0);

    uint8_t header = (uint8_t)hdp_pci_read16(bus, device, 0, 0x0E);

    if (header & 0x80) {
        for (function = 1; function < 8; function++)
            scan_func(bus, device, function);
    }
}