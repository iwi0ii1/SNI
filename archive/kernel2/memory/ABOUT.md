# Memory Subsystem

This directory contains the **memory management logic of the kernel**.

## What this subsystem does

The memory subsystem is responsible for managing how the operating system uses RAM after the hardware has been initialized by the architecture layer.

It provides higher-level memory services used by the rest of the kernel.

## Responsibilities

- Physical memory allocation (page allocator)
- Virtual memory management
- Heap allocator (kernel heap / kmalloc-style system)
- Memory region tracking
- Address space management
- Memory usage policies and fragmentation handling

## What it does NOT do

- It does NOT configure paging hardware directly
- It does NOT interact with CPU registers or MMU instructions
- It does NOT handle bootloader memory parsing directly
- It does NOT implement architecture-specific memory setup

Those responsibilities belong to `kernel/arch/`.

## Relationship with architecture layer

The memory subsystem depends on architecture-provided primitives such as:
- page table setup functions
- memory map information (passed during boot)
- low-level mapping/unmapping helpers

However, it should NOT contain architecture-specific code itself.

## Design goal

The memory subsystem should be:
- architecture-independent in logic
- reusable across different CPU architectures
- focused on allocation strategy and memory organization

## Summary

Think of this subsystem as:

> “The system that decides how RAM is allocated and used by the kernel”