# Set Up Layer (SUL)
The **Set Up Layer (SUL)** is the early kernel initialization stage responsible for configuring the processor execution environment and enabling protected kernel operation.

This layer performs architecture-critical setup before entering the main kernel runtime.

## Core responsibilities

### Memory Management initialization
 - Enable paging
 - Build initial page tables
 - Configure page directory structures
 - Activate virtual memory

### Descriptor table setup
 - Initialize the Global Descriptor Table (GDT)
 - Load segment descriptors
 - Configure Task State Segment (TSS)

### Descriptor Table Setup
 - Initialize the Global Descriptor Table (GDT)
 - Load segment descriptors
 - Configure Task State Segment (TSS)

### Interrupt System Initialization
 - Build and load the Interrupt Descriptor Table (IDT)
 - Configure interrupt service routines (ISR)
 - Remap and initialize the PIC/APIC
 - Enable hardware interrupts

### CPU Environment Preparation
 - Switch CPU modes (Real → Protected → Long Mode)
 - Configure control registers (CR0, CR3, CR4)
 - Enable SSE/SIMD features if required

### Early Hardware Initialization
PIT/APIC timer setup
Keyboard controller initialization
Serial debug interface setup