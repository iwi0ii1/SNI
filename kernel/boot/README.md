# Boot phase
The Boot Phase is the initial execution stage of the system, responsible for loading the kernel and preparing the minimal environment required to start kernel execution.

It exists entirely outside the kernel proper.

## Responsibilities
### System Loading
 - Load kernel binary into memory
 - Load initial RAM disk (if present)
 - Parse boot parameters
 - Transfer control to kernel entry point

### Early Hardware Setup (minimal)
 - Switch CPU from firmware/real mode → protected/long mode (depending on architecture)
 - Set up initial memory map
 - Provide hardware information (ACPI/UEFI tables)

### Environment Preparation
 - Establish stack for kernel entry
 - Pass boot-time structures (memory map, framebuffer, etc.)
 - Disable firmware control