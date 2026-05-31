# Hardware Discovery Phase (HDP)
The Hardware Discovery Phase (HDP) is responsible for detecting and identifying all available hardware devices during system initialization.

It does not control hardware deeply — it only finds and describes it.

## Responsibilities
### Device Enumeration
 - Scan PCI/PCIe bus
 - Detect USB devices
 - Identify storage controllers
 - Enumerate ACPI tables
 - Detect CPU features

### Hardware Identification
 - Read device IDs and vendor IDs
 - Classify device types
 - Match devices to supported drivers

### System Topology Discovery
 - CPU core detection
 - NUMA node mapping (if supported)
 - Interrupt routing tables (IOAPIC/APIC)
 - Memory map (from bootloader/UEFI)

### Capability Reporting
 - Feature flags (SSE, AVX, virtualization support)
 - Device capabilities (DMA, MSI/MSI-X support)
 - Power states and ACPI info