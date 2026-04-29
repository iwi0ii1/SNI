# Drivers Subsystem

This directory contains all **hardware driver implementations**, designed to run as **user-space processes** rather than being built directly into the kernel.

## What “drivers” mean

Drivers are independent processes responsible for communicating with hardware devices and exposing them as usable services to the rest of the system.

Instead of being part of the kernel, they interact with it through well-defined communication channels (e.g., IPC).

## Responsibilities

- Handling keyboard and mouse input events  
- Managing display/framebuffer or GPU communication  
- Interfacing with storage devices (disks, partitions)  
- Providing network device access  
- Communicating with hardware controllers and buses (USB, PCI, etc.)  

## What drivers do NOT do

- Scheduling or process management  
- Memory allocation policy  
- System calls or kernel control flow  
- Bootstrapping or early initialization  

These responsibilities remain in `core/` or `arch/`.

## Relationship with the kernel

Drivers do not execute in kernel space. Instead, they:

- Run as isolated processes  
- Communicate with the kernel via IPC mechanisms  
- Request privileged operations through controlled kernel interfaces  

The kernel acts as a mediator between drivers and hardware access when necessary.

## Relationship with architecture

Drivers may rely on low-level primitives exposed by:

- `arch/x86/` (e.g., I/O access, interrupts, memory mapping)

However, they must not implement or depend on architecture-specific logic directly. All such interactions should go through kernel-provided abstractions.

## Design goal

Drivers act as **isolated service providers** that translate hardware behavior into system-level interfaces.

Ideal flow:

```
[ Hardware ] ⇄ [ Driver Process ] ⇄ [ Kernel IPC ] ⇄ [ Core System / Applications ]
```

## Important rules

Drivers should be:

- **Isolated** — failures should not crash the kernel  
- **Replaceable** — can be restarted or swapped independently  
- **Minimal in privilege** — only access what they strictly need  
- **Decoupled** — no direct dependency on kernel subsystems like scheduling  

## Summary

Think of `drivers/` as:

> “A collection of user-space services that handle hardware communication through the kernel”