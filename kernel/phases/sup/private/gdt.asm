; Defines the CPU's execution and privilege rules (kernel/user code, system tasks, protected execution contexts).
; Example: kernel code can execute at Ring 0, user apps can only execute at Ring 3.

%macro GDT_ENTRY 5
; base, limit, access, flags, label
%5:
    dw %2 & 0xFFFF
    dw %1 & 0xFFFF
    db (%1 >> 16) & 0xFF
    db %3
    db ((%2 >> 16) & 0x0F) | ((%4 & 0x0F) << 4)
    db (%1 >> 24) & 0xFF
%endmacro

; Access byte helpers
%define ACC_CODE 10011000b
%define ACC_DATA 10010010b

; Privilege levels
%define RING0    00000000b
%define RING3    01100000b

%define FLAT_64  0010b        ; L=1
%define FLAT_32  1100b        ; G=1, D=1
%define FLAT_DATA 1000b       ; G=1




bits 32
global sup_gdt_init
global sup_gdt_ptr

section .data
; The table (updating this table signals changing api/selector.inc due to assumptions in order)
sup_gdt_table_start:
    dq 0x0 ; null (0x0, required by CPU)

    GDT_ENTRY 0, 0xFFFFF, (ACC_CODE | RING0), FLAT_64, gdt_kernel_code64 ; kernel 64-bit code (0x8)
    GDT_ENTRY 0, 0xFFFFF, (ACC_CODE | RING3), FLAT_64, gdt_user_code64   ; user 64-bit code (0x10)

    GDT_ENTRY 0, 0xFFFFF, (ACC_CODE | RING0), FLAT_32, gdt_kernel_code ; kernel 32-bit code (0x18)
    GDT_ENTRY 0, 0xFFFFF, (ACC_CODE | RING3), FLAT_32, gdt_user_code   ; user 32-bit code (0x20)
    
    GDT_ENTRY 0, 0xFFFFF, (ACC_DATA | RING0), FLAT_DATA, gdt_kernel_data ; kernel data (0x28)
    GDT_ENTRY 0, 0xFFFFF, (ACC_DATA | RING3), FLAT_DATA, gdt_user_data   ; user data (0x30)
sup_gdt_table_end:

sup_gdt_ptr:
    dw sup_gdt_table_end - sup_gdt_table_start - 1
    dd sup_gdt_table_start
    



section .text
sup_gdt_init:
    ; Load descriptor table into CPU
    lgdt [sup_gdt_ptr]

    ; The CPU executes according to the execution descriptor from CS.
    ; However, CS still holds old policy, we need to change it to the new one.
    jmp 0x18:.flush

.flush:
    mov ax, 0x28 ; 0x28 is `gdt_kernel_data` entry according to the table.

    ; Not ready to touch SS yet.
    ; mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax



    ret