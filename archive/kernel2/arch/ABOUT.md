# Architecture Subsystem

This directory contains all **architecture-specific code** for the kernel.

## What “architecture” means

The architecture subsystem handles everything related to how the kernel interacts directly with the CPU and hardware platform.

Each supported CPU architecture (e.g. x86, ARM) has its own implementation.

## Responsibilities

- Boot process entry point
- CPU initialization
- Interrupt and exception handling (IDT / vectors)
- Paging setup and MMU configuration
- Low-level memory operations
- Context switching (register save/restore)
- System call entry mechanisms
- Hardware-specific I/O access (ports, MSRs, etc.)

## Structure

Each architecture is isolated in its own folder:

 - arch/
 - x86/
 - boot/
 - cpu/
 - memory/
 - interrupt/

   
## What it does NOT do

- It does NOT implement high-level OS logic (scheduler, processes, heap)
- It does NOT manage drivers or devices directly
- It does NOT implement user-level system behavior

Those responsibilities belong to `kernel/core/`, `kernel/memory/`, and `drivers/`.

## Relationship with other subsystems

Architecture code provides **low-level primitives** that other kernel subsystems depend on.

Example:
- Memory subsystem uses arch functions for paging
- Core subsystem uses arch code for interrupts and syscalls
- Drivers use arch for hardware access

## Design goal

The architecture phase should be:
- as thin and low-level as possible
- tightly bound to hardware specifics
- isolated per CPU family

It should act as the **hardware abstraction boundary of the kernel**.

## Summary

Think of this subsystem as:

> “The layer that makes the kernel aware of the CPU and hardware it runs on”