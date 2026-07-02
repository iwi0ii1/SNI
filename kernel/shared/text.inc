; Everything related to printing texts on screen
bits 64

; Print character relative to the current cursor position
; Parameter: DIL for character (not ptr)
; Parameter: SIL for color attribute
extern ks_shared_textPutc

; Print string but automatically scrolls and relative to the current cursor position
; Parameter: RDI for first char ptr
; Parameter: SIL for color attribute
; Note: String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)
extern ks_shared_textAputs

; Fill VGATGB with a color
; Parameter: DIL for character to fill
; Parameter: SIL for color attribute
extern ks_shared_textFillChar

; Reposition cursor
; Parameter: DI for x coord
; Parameter: SI for y coord
; Note: 0 based
extern ks_shared_textRepositionCursor

; Get cursor position
; Return: AH -> x coord
; Return: AL -> y coord
; Note: 0 based
extern ks_shared_textGetCursorPos

; Newline cursor
; Parameter: DIL for repetitions
; Note: Will scroll if reached bottom
extern ks_shared_textNewlineCursor