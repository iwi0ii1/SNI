%include "phases/ecp/private/modes/extensions.inc"
%include "phases/ecp/private/modes/features.inc"
%include "phases/ecp/private/modes/system.inc"

bits 64
global ecp_modes_init

extern ecp

section .text
ecp_modes_init:
    call ecp_modes_enable_wp      ; Turn on Supervisor Write Protection
    call ecp_modes_enable_mmx     ; Turn on MMX hardware vector engine
    call ecp_modes_enable_sse     ; Turn on SSE hardware vector engine
    call ecp_modes_enable_syscall ; Turn on EFER System Call extensions

    ret