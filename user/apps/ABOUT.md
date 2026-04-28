# User Applications (Default Apps)

This directory contains the **default applications shipped with the operating system**.

These are user-space programs that run on top of the kernel and system services.

## What “apps” means

Applications are programs that provide functionality directly to the user, such as tools, utilities, and interactive software.

## Responsibilities

- User-facing programs (UI or CLI)
- System utilities (file viewer, editor, shell tools)
- Built-in default applications for the OS
- Simple demos or reference programs for the system

## What apps do NOT do

- They do NOT manage hardware directly
- They do NOT access kernel memory or CPU registers
- They do NOT implement drivers or OS core logic
- They do NOT handle scheduling or memory management

Apps must rely on system APIs provided by the kernel or system layer.

## Relationship to the system

Applications interact with the OS through:
- system calls
- libraries (if available)
- system services (if implemented)

They do NOT interact directly with `arch/` or `drivers/`.

## Design goal

This directory exists to provide:
- a default user experience
- test applications for OS development
- a foundation for a future userland

## Summary

Think of this directory as:

> “The collection of programs the user actually runs”