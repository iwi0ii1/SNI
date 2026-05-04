# Core Subsystem

This directory contains the **core logic of the operating system kernel**.

## What “core” means

The core subsystem is responsible for **operating system behavior**, not hardware interaction. It defines how the system runs, schedules work, and manages execution flow.

## Responsibilities

- Process management
- Thread management
- Scheduler implementation
- System call handling
- Kernel time management
- Basic synchronization primitives (locks, mutexes, etc.)

## What it does NOT contain

- Hardware-specific code (CPU instructions, paging setup, interrupts)
- Device drivers (keyboard, disk, display hardware)
- Bootloader or early initialization code
- Direct I/O port or MMU manipulation

Those belong to `arch/` or `drivers/`.

## Design goal

The core should remain **as architecture-independent as possible**.

If properly designed, this code should not need to change when:
- switching CPU architectures (x86 → ARM, etc.)
- changing boot methods (Multiboot2 → UEFI, etc.)

## Dependency rules

Core code may depend on:
- memory subsystem (kernel/memory)
- architecture abstraction interfaces (kernel/arch/* interfaces)

Core code must NOT depend directly on:
- hardware registers
- bootloader data structures
- device-specific logic

## Summary

Think of `core/` as:

> “The decision-making and scheduling brain of the kernel”