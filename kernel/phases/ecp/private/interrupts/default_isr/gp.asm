bits 64
global ecp_interrupts_default_isr_gp

section .text

align 16
ecp_interrupts_default_isr_gp:
    cli

    ; Hardware stack state on entry:
    ; [rsp + 0]  = Error Code (Contains the Selector Index or 0)
    ; [rsp + 8]  = Faulting RIP (The exact instruction that caused the #GP)

    ; 1. Extract diagnostics into dedicated registers without using 'push'
    mov rax, [rsp + 8]          ; RAX = Faulting RIP
    mov rcx, [rsp + 0]          ; RCX = Error Code / Selector Index

    ; 2. For GDB debugging
    mov r12, rax                ; R12 = Safe backup of RIP
    mov r13, rcx                ; R13 = Safe backup of Error Code

    ; 3. Write red "#GP"
    mov word [0xB8000], 0x4F23 ; '#'
    mov word [0xB8002], 0x4F47 ; 'G'
    mov word [0xB8004], 0x4F50 ; 'P'

.gp_park:
    hlt
    jmp .gp_park