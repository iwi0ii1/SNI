bits 64
global ecp_exceptions_default_isr_df

section .text

align 16
ecp_exceptions_default_isr_df:
    cli

    ; 1. Capture the faulting RIP from the hardware stack frame into RAX
    ; [rsp + 0]  = Error Code
    ; [rsp + 8]  = Faulting RIP (for GDB)
    mov rax, [rsp + 8]          ; RAX now contains the exact instruction that died

    ; 2. Write red "#DF"
    mov word [0xB8000], 0x4F23 ; '#'
    mov word [0xB8002], 0x4F44 ; 'D'
    mov word [0xB8004], 0x4F46 ; 'F'

    ; 3. Park the instruction pointer inside a dedicated register loop.
    ; By copying the broken address to RBX, it sits permanently safe from stack corruption.
    mov rbx, rax                ; RBX = Backup of the faulting RIP for diagnostic lookup

.dead_park:
    hlt                         ; Power down the core execution pipeline
    jmp .dead_park              ; Loop tight if an NMI or system trace wakes it up