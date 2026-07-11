; Collection stage of loader, collect e820, VBE, load boot config (sector 2048), and preserve boot drive (at DL)

%include "bios/macros.inc"

%define LS_COLLECTION_COMMONSTR "> Loader collection stage: "

bits 16

section .ls_collection
ls_collection: ; Stage 2
    mov sp, 0x7BFF ; Reload stack ptr bc of foundation's far jump.

    mov byte [.boot_drive], dl ; Save Boot drive in `.boot_drive`, can't guarantee DL will preserve.

    call get_e820          ; Collect e820 memory map
    call get_vbe_ctrl_info ; Collect VBE controller info
    call load_boot_config  ; Load boot config

.done:
    ; Tell that loader's foundation has been done
    xor ax, ax
    mov ds, ax
    mov si, .tell_done_str ; This is safe as long as `.tell_done_str` doesn't pass (0x7DFE - strlen) in memory

    call print_str

    mov dl, byte [.boot_drive]

    jmp 0x8000

.tell_done_str: db LS_COLLECTION_COMMONSTR, "done.", 0

.boot_drive: db 0



get_e820:
    xor ebx, ebx ; continuation value = 0

    ; Info dest
    xor ax, ax
    mov es, ax
    mov di, LS_COLLECTION_E820_LOAD_DEST

.next:
    mov eax, 0xE820
    mov edx, 0x534D4150 ; "SMAP"
    mov ecx, 24         ; request 24-byte entry

    int 0x15

    jc .fail      ; BIOS error

    cmp eax, 0x534D4150
    jne .fail     ; BIOS didn't return SMAP

    add di, 24    ; next buffer slot

    test ebx, ebx ; EBX = 0 means finished
    jnz .next

    ret

.fail:
    xor ax, ax
    mov ds, ax
    mov si, .tell_fail_str
    call print_str

.hang:
    hlt
    jmp .hang

.tell_fail_str: db LS_COLLECTION_COMMONSTR, "failed to retrieve e820 memory map!", 0



get_vbe_ctrl_info:
    ; Info dest
    xor ax, ax
    mov es, ax
    mov di, LS_COLLECTION_VBE_CTRL_INFO_DEST

    ; VBE function 4F00h: Return VBE Controller Information
    mov ax, 0x4F00

    mov dword [es:di], 0x32454256 ; VBE expects "VBE2" at ES:DI

    int 0x10

    cmp ax, 0x004F ; 0x004F means successful
    jne .fail

    ret

.fail:
    xor ax, ax
    mov ds, ax
    mov si, .tell_fail_str
    call print_str

.hang:
    hlt
    jmp .hang

.tell_fail_str:
    db LS_COLLECTION_COMMONSTR, "failed to retrieve VBE controller info!", 0



load_boot_config:
    mov dl, [ls_collection.boot_drive]

    ; ES:BX = load dest
    mov ax, LS_COLLECTION_BOOTCFG_LOAD_DEST
    mov es, ax
    xor bx, bx

    mov si, .dap
    mov ah, 0x42
    int 0x13
    jc .fail

    ret

.dap:
    db 0x10                               ; DAP size
    db 0x00                               ; reserved
    dw LS_COLLECTION_BOOTCFG_SECTOR_COUNT ; sectors to read
    dw LS_COLLECTION_BOOTCFG_LOAD_DEST    ; buffer offset
    dw 0                                  ; buffer segment
    dq LS_COLLECTION_BOOTCFG_SECTOR       ; LBA sector

.fail:
    xor ax, ax
    mov ds, ax
    mov si, .tell_fail_str
    call print_str

.hang:
    hlt
    jmp .hang

.tell_fail_str:
    db LS_COLLECTION_COMMONSTR, "failed to load boot config, must be at sector ", ('0' + LS_COLLECTION_BOOTCFG_SECTOR), "!", 0



print_str: ; DS:SI str source, note: must be null-terminated
    mov ax, 0xB80A
    mov es, ax
    xor di, di

.lup:
    mov ah, 0xF0 ; Forced color attribute: Black fg White bg
    lodsb ; Load current char from DS:SI to AL

    test al, al
    jz .false

    cmp di, 0x140 ; Limit to 160 characters getting printed
    jae .false
    
    stosw ; Store AX to ES:DI
    jmp .lup

.false:
    ret

times 512 - ($ - $$) db 0 ; Ensure 512 bytes with 0 filling