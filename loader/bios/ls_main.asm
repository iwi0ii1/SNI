; Concatenate assembly and turn into a final binary: loader.bin

%include "bios/foundation.asm"
times 510 - ($ - $$) db 0 ; BIOS signature
dw 0xAA55

%include "bios/collection.asm"
times 512 - ($ - $$) db 0 ; Ensure 512 bytes with 0 fillings

%include "bios/application.asm"
times 512 - ($ - $$) db 0 ; Same