#pragma once

#include "hdp/private/pci/device.h"
#include "hdp/private/pci/read.h"

extern void hdp_pci_scan_device(const uint8_t bus, const uint8_t device); // Scan devices through PCI, cuh
extern void hdp_pci_scan_bus(void); // Scan the PCI bus, cuh