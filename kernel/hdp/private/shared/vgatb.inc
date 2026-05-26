; Everything related to VGATB

; HDP's VGATGB char printer relative to cursor position
; Parameter: RDI for char
; Parameter: SIL for color attribute
extern hdp_shared_putc

; HDP's VGATGB string printer, but automatically scrolls and relative to cursor position
; Parameter: RDI for first char ptr
; Parameter: SIL for color attribute
; Note: String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)
extern hdp_shared_aputs

; HDP's VGATB filler
; Parameter: DIL for color attribute
extern hdp_shared_fill_vgatb

; HDP's VGATGB cursor repositioner
; Parameter: DI for x coord
; Parameter: SI for y coord
; Note: 0 based
extern hdp_shared_reposition_cursor

; HDP's VGATGB cursor position retriever
; Return: AH -> x coord
; Return: AL -> y coord
; Note: 0 based
extern hdp_shared_get_cursor_pos