; Everything related to memory. Such as comparing bytes, perform a specific operation on bytes.

; Compare string of bytes
; Parameter: RDI for first string (ptr)
; Parameter: RSI for second string (ptr)
; Parameter: EDX for bytes count to compare
; Return: AL of 0 for same, 1 for different
extern shared_mem_cmp