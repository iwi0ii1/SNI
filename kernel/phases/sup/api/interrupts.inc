; Dependency file: idt.asm

; API: register handler for interrupt vector
bits 64

extern sup_idt_set_handler

%macro SUP_API_REGISTER_ISR 2
    mov rdi, %1      ; handler
    mov si, %2      ; vector
    call sup_idt_set_handler
%endmacro