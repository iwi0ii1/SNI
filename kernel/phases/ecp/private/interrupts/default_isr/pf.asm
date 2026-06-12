bits 64
global ecp_interrupts_default_isr_pf

section .text

align 16
ecp_interrupts_default_isr_pf:
    cli

    ; Hardware stack state on entry:
    ; [rsp + 0]  = Page Fault Error Code (Bitmask containing why it failed)
    ; [rsp + 8]  = Faulting RIP (The instruction that tried to touch the address)

    ; 1. Get critical #PF details
    mov rax, [rsp + 8]          ; RAX = Faulting RIP
    mov rcx, [rsp + 0]          ; RCX = Error Code bitmask
    mov rdx, cr2                ; RDX = The unmapped address that caused the fault!

    ; 2. Stash them safely in upper registers for GDB triage
    mov r12, rax                ; R12 = Faulting RIP
    mov r13, rcx                ; R13 = Fault Fault Reason Bitmask
    mov r14, rdx                ; R14 = THE BAD MEMORY ADDRESS

    ; 3. Write red "#PF"
    mov word [0xB8000], 0x4F23 ; '#'
    mov word [0xB8002], 0x4F50 ; 'P'
    mov word [0xB8004], 0x4F46 ; 'F'

.pf_park:
    hlt
    jmp .pf_park