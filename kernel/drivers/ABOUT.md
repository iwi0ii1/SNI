# Drivers Subsystem

This directory contains all **hardware driver implementations** for the operating system.

## What “drivers” mean

Drivers are responsible for communicating with hardware devices and translating them into usable interfaces for the kernel.

## Responsibilities

- Keyboard and mouse input handling
- Display/framebuffer or GPU output
- Storage devices (disk, partitions)
- Network interfaces (if implemented)
- Hardware controllers and buses (USB, PCI, etc.)

## What drivers do NOT do

- Scheduling or process management
- Memory allocation policy
- System calls or kernel logic
- Boot process handling

Those belong to `core/` or `arch/`.

## Relationship with architecture

Drivers may use low-level hardware access provided by:

- `arch/x86/` (e.g., I/O ports, interrupts, MMU helpers)

However, drivers should NOT directly implement architecture logic themselves.

## Design goal

Drivers should act as a **translation layer** between hardware and the kernel.

Ideal flow:

## Important rule

Drivers should be:
- replaceable
- isolated per device type
- not dependent on OS logic (like scheduler or process system)

## Summary

Think of `drivers/` as:

> “The hardware communication layer of the OS”