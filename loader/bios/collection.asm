; Collection stage of loader, collect e820, VBE, load boot config (sector 2048), and preserve boot drive (at DL)

%define LS_COLLECTION_COMMONSTR "SNI's loader's collection stage has "

bits 16

section .ls_collection
ls_collection: ; Stage 2
    mov sp, 0x7BFF ; Reload stack ptr bc of foundation's far jump.

    call get_e820 ; Collect e820 memory map
    ; Collect VBE graphics info
    ; Load boot config

.done:
    ; Tell that loader's foundation has been done
    xor ax, ax
    mov ds, ax
    mov si, .tell_done_str ; This is safe as long as `.tell_done_str` doesn't pass (0x7DFE - strlen) in memory

    call print_str

    jmp 0x8000

.tell_done_str: db LS_COLLECTION_COMMONSTR, "successfully done its job.", 0



get_e820:
    xor ebx, ebx          ; continuation = 0
    mov di, .e820_struct

.next:
    mov eax, 0xE820
    mov edx, 0x534D4150   ; "SMAP"
    mov ecx, 24           ; ask for ACPI extended entry
    int 0x15

    jc .fail

    cmp eax, 0x534D4150
    jne .fail

    ; buffer now contains an entry

    add di, 24

    test ebx, ebx
    jnz .next
    
.e820_struct:
    dq 0
    dq 0
    dw 0

.fail:
    xor ax, ax
    mov ds, ax
    mov si, .tell_fail_str
    call print_str

.tell_fail_str: db LS_COLLECTION_COMMONSTR, "failed to retrieve e820 memory map!", 0



print_str: ; DS:SI str source, note: must be null-terminated
    mov ax, 0xB80A
    mov es, ax
    xor di, di

.lup:
    mov ah, 0xF0 ; Forced color attribute: Black fg White bg
    lodsb ; Load current char from DS:SI to AL

    test al, al
    jz .false

    cmp di, 0xA0 ; Limit to 80 characters getting printed
    jae .false
    
    stosw ; Store AX to ES:DI
    jmp .lup

.false:
    ret