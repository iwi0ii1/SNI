; Dependency file: idt.asm

; API: register handler for interrupt vector
bits 64

; Basically an ISR installer. But in the computer term, it is known as `gate`.
; Parameter: DIL: vector number, RSI: ISR ptr
extern ecp_interrupts_set_gate