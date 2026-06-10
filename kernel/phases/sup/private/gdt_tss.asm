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

section .bss
sup_gdt_tss: resq 26

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

sup_gdt_table_tss: ; TSS (0x38)
    dq 0, 0
sup_gdt_table_end:

sup_gdt_ptr:
    dw sup_gdt_table_end - sup_gdt_table_start - 1
    dd sup_gdt_table_start

section .text
sup_gdt_init:
    lgdt [sup_gdt_ptr]
    jmp 0x18:.flush

.flush:
    mov ax, 0x28 
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov eax, [sup_gdt_ptr + 2]
    lea ebx, [eax + sup_gdt_table_tss - sup_gdt_table_start]

    ; -------- Safe TSS Base Extraction --------
    mov edx, sup_gdt_tss
    mov word [ebx + 2], dx   ; Base Bits 0-15  -> Byte 2 and 3
    
    mov eax, edx
    shr eax, 16
    mov byte [ebx + 4], al   ; Base Bits 16-23 -> Byte 4
    
    mov eax, edx
    shr eax, 24
    mov byte [ebx + 7], al   ; Base Bits 24-31 -> Byte 7

    ; -------- Clear High 32-bits for the 64-bit slot --------
    mov dword [ebx + 8], 0   

    ; -------- Setup Size Limit and Attribute Bytes --------
    mov word [ebx + 0], 104-1
    mov byte [ebx + 6], 00000000b ; Clear byte 6 cleanly
    mov byte [ebx + 5], 10001001b ; Type: Available 32/64 TSS

    ret