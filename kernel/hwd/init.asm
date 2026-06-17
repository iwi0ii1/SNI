; Init in interface phase is weird, but this init is for initailizing internal states
%include "hwd/private/exposed.inc"

bits 64
global hwd_init

section .text
hwd_init:
    call hwd_firmware_init
    call hwd_buses_init
    call hwd_devices_init

    ret