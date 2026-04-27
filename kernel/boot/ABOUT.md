# Boot Subsystem

This directory contains the **boot-time layer of the operating system**.

It is responsible for everything that happens between the bootloader handing control to the kernel and the moment the kernel proper begins execution.

## What “boot” means here

The boot subsystem is the bridge between:
- the bootloader (GRUB / Limine / UEFI / BIOS chain)
- the kernel core execution

It handles all bootloader-specific differences and prepares a clean starting state for the kernel.

## Responsibilities

- Receiving control from the bootloader
- Parsing bootloader-provided data (e.g. Multiboot2, Limine, UEFI memory maps)
- Extracting useful system information (memory map, framebuffer, modules, etc.)
- Converting bootloader-specific formats into internal kernel-friendly structures
- Performing minimal early initialization required before the kernel starts
- Passing control to the kernel entry function

## What this does NOT do

- It does NOT implement kernel logic (scheduler, processes, syscalls)
- It does NOT manage drivers or hardware devices
- It does NOT contain architecture-specific CPU setup (that belongs in `arch/`)
- It does NOT handle long-term memory management or system services

## Relationship with other subsystems

- Bootloaders (GRUB, Limine, UEFI firmware) provide the initial control transfer
- Architecture layer (`arch/`) handles CPU-specific initialization after boot
- Core kernel (`kernel/core/`) begins execution after boot completes

## Design goal

The boot subsystem should:
- isolate bootloader differences
- normalize all boot data into a unified format
- keep kernel core independent of boot methods
- remain minimal and disposable after initialization

## Summary

Think of this subsystem as:

> "The translation layer between bootloader chaos and kernel clarity"