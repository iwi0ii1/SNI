; Init in interface phase is weird, but this init is for initailizing internal states
%include "phases/hip/private/exposed.inc"

bits 64
global hip_init

section .text
hip_init:
    call hip_firmware_init
    call hip_buses_init
    call hip_devices_init
    call hip_interfaces_init

    ret