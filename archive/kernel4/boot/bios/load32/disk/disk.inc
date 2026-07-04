bits 32

; Load from disk
; Param EDI: Sector to read
; Param ESI: Sector count
; Param EDX: Load dest
; Param CX: Drive number
extern l32_disk_load