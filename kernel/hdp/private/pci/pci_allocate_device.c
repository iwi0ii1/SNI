#include "pci.h"

extern uint32_t hdp_pci_device_count;
extern struct hdp_pci_device_t hdp_pci_device_list[];

struct hdp_pci_device_t* hdp_pci_allocate_device(void) {
    return &hdp_pci_device_list[hdp_pci_device_count];
}