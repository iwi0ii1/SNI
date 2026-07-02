; Init in interface phase is weird, but this init is for initailizing internal states
bits 64
global ks_hwd_init

extern ks_hwd_firmware_init
extern ks_hwd_platforms_init
extern ks_hwd_controllers_init
extern ks_hwd_cpu_init

section .text
ks_hwd_init:
    call ks_hwd_firmware_init
    call ks_hwd_platforms_init
    call ks_hwd_controllers_init
    call ks_hwd_cpu_init

    ret