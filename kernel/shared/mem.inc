; Everything related to memory. Such as comparing bytes, perform a specific operation on bytes.

; Compare string of bytes
; Parameter: RDI for first string (ptr)
; Parameter: RSI for second string (ptr)
; Parameter: EDX for bytes count to compare
; Return: EAX of 0 for same, else different
extern hdp_shared_memcmp