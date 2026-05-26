; Everything related to VGATB

; Print character relative to the current cursor position
; Parameter: DIL for character (not ptr, address)
; Parameter: SIL for color attribute
extern hdp_shared_putc

; Print string but automatically scrolls and relative to the current cursor position
; Parameter: RDI for first char ptr
; Parameter: SIL for color attribute
; Note: String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)
extern hdp_shared_aputs

; HDP's VGATB filler
; Parameter: DIL for color attribute
extern hdp_shared_fill_vgatb

; Reposition cursor
; Parameter: DI for x coord
; Parameter: SI for y coord
; Note: 0 based
extern hdp_shared_reposition_cursor

; Get cursor position
; Return: AH -> x coord
; Return: AL -> y coord
; Note: 0 based
extern hdp_shared_get_cursor_pos

; Newline cursor
; Note: Will scroll if reached bottom
extern hdp_shared_newline_cursor