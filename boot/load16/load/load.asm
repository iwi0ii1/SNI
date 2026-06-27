bits 16
global l16_load_from_disk

section .text
l16_load_from_disk:
    ; 1. Construct DAP on stack
    sub sp, 16 ; 16 bytes
    mov bx, sp
    
    mov byte [bx], 0x10    ; DAP Size: 16 bytes
    mov byte [bx + 1], 0   ; Mandatory
    mov word [bx + 2], si  ; Sector count to read
    mov word [bx + 4], dx  ; Load dest (low 16: offset)
    shr edx, 16            
    mov word [bx + 6], dx  ; Load dest (high 16: segment)
    mov dword [bx + 12], 0 ; Sector location (up 4)

    ; 2. Load it...
    mov ah, 0x42 ; Read with LBA
    mov dl, 0x80 ; First drive
    mov si, bx   ; Ptr to DAP

    int 0x13
    jc .error
    
    ; 3. Restore stack
    add sp, 16
    
    ret

.error:
    mov ax, 0xB800
    mov es, ax
    mov word [es:0], 0x4F45