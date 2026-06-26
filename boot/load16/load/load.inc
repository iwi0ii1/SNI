; Load from Disk to RAM
bits 16
; Load from disk to RAM
; Param DX:AX for sector location
; Param DS:SI for sectors needed to contain binary
; Param CX:BX for RAM location
extern l16_load_from_disk