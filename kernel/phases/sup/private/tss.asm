; Provides the kernel stack used when switching from user mode to kernel mode.
; Allows the CPU to safely handle privilege-level transitions and interrupts.

bits 64
global sup_tss_init

section .text
sup_tss_init:
    