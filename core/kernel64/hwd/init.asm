; Init in interface phase is weird, but this init is for initailizing internal states
%include "hwd/private/exposed.inc"

bits 64
global k64_hwd_init

section .text
k64_hwd_init:
    call k64_hwd_firmware_init
    call k64_hwd_buses_init
    call k64_hwd_controllers_init
    call k64_hwd_cpu_init

    ret