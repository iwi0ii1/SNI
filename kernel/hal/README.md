# Hardware Abstraction Layer (HAL)
The HAL (Hardware Abstraction Layer) sits above HDL and provides a uniform API for hardware interaction, hiding architecture-specific and device-specific details.

## Responsibilities
### Unified Device Interfaces
 - Standard APIs for storage, input, networking
 - Device-agnostic read/write operations

### Driver Abstraction
 - Wrap hardware-specific drivers
 - Convert device behavior into generic interfaces

### Architecture Isolation
 - Hide differences between x86 / ARM / RISC-V
 - Standardize interrupts, timers, and memory access

### System Services for Kernel Core
 - Timer APIs
 - Interrupt management APIs
 - Memory-mapped I/O abstraction
 - Power management interface