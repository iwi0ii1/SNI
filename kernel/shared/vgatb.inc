; Everything related to VGATB

; Print character relative to the current cursor position
; Parameter: DIL for character (not ptr)
; Parameter: SIL for color attribute
extern shared_vgatb_putc

; Print string but automatically scrolls and relative to the current cursor position
; Parameter: RDI for first char ptr
; Parameter: SIL for color attribute
; Note: String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)
extern shared_vgatb_aputs

; Fill VGATGB with a color
; Parameter: DIL for character to fill
; Parameter: SIL for color attribute
extern shared_vgatb_fill_char

; Reposition cursor
; Parameter: DI for x coord
; Parameter: SI for y coord
; Note: 0 based
extern shared_vgatb_reposition_cursor

; Get cursor position
; Return: AH -> x coord
; Return: AL -> y coord
; Note: 0 based
extern shared_vgatb_get_cursor_pos

; Newline cursor
; Note: Will scroll if reached bottom
extern shared_vgatb_newline_cursor