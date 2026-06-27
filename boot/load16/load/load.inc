; Load from Disk to RAM
bits 16
; Load from disk to RAM
; Param EDI for sector location
; Param SI for sectors needed to contain binary
; Param EDX for RAM location (up 16 segment, low 16 offset)
; Note: Never know u can do 32-bit regs in real mode.
extern l16_load_from_disk