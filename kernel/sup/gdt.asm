; Defines the CPU's execution and privilege rules (kernel/user code, system tasks, protected execution contexts).
; Example: kernel code can execute at Ring 0, user apps can only execute at Ring 3.

bits 32
global sup_gdt_init
global sup_gdt_ptr

section .data
; The table
sup_gdt_table_start:
    dq 0x0 ; null (0x0, required by CPU)
    dq 0x00209A0000000000   ; 64-bit code (L=1)
    dq 0x0000920000000000   ; data
sup_gdt_table_end:

sup_gdt_ptr:
    dw sup_gdt_table_end - sup_gdt_table_start - 1
    dq sup_gdt_table_start
    



section .text
sup_gdt_init:
    ; Load descriptor table into CPU
    lgdt [sup_gdt_ptr]

    ; The CPU executes according to the execution descriptor from CS.
    ; However, CS still holds old policy, we need to change it to the new one.
    jmp 0x8:.flush

.flush:
    ; These old segments still holds old data descriptor, we need to change them for consistency.
    mov ax, 0x10

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ret