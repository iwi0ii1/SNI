; Everything related to memory. Such as comparing bytes, perform a specific operation on bytes.

; Compare string of bytes
; Parameter: RDI for first string (ptr)
; Parameter: RSI for second string (ptr)
; Parameter: EDX for bytes count to compare
; Return: AL of 0 for same, 1 for different
extern shared_mem_cmp

%define SHARED_MEM_BIN_TAG 2
%define SHARED_MEM_OCT_TAG 8
%define SHARED_MEM_DEC_TAG 10
%define SHARED_MEM_HEX_TAG 16

; Convert unsigned 64-bit integer to string
; Parameter: RDI for destination (ptr)
; Parameter: RSI for the unsigned 64-bit integer
; Parameter: DL for base to represent in string (binary, octal, decimal, hexal)
extern shared_mem_u64_to_str