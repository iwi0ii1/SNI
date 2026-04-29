#!/bin/bash
set -e



if [[ $# -eq 0 ]]; then
    args=("$@")

    mkdir -p build
    
    SOURCES=$(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \) -print)
    
    OBJS=()

    for file in "${SOURCES[@]}"; do
        newpath=$(echo "$file" | sed 's/\//_/g')

        case "$file" in
            *.cpp)
                printf "\n[+] Compiling $file -> $newpath"
                g++ -ffreestanding -nostdlib -fno-exceptions -fno-rtti -O0 -m64 \
                    -c "$file" -o "$newpath"
                ;;
        
            *.c)
                printf "\n[+] compiling: $file -> $obj"
                gcc -ffreestanding -nostdlib -O0 -m64 \
                    -c "$file" -o "$obj"
                ;;
        
            *.asm)
                printf "\n[+] assembling: $file -> $obj"
                nasm -f elf64 "$file" -o "$obj"
                ;;
        
            *)
                printf "[-] Unknown file type: $file"
                exit 1
                ;;
        esac

        OBJS+=("$newpath")
    done

    printf "\n[+] Linking kernel...\n"

    ld -nostdlib -m elf_x86_64 -T "$KERNEL_DIR/linker.ld" -o "$OUT" "${OBJS[@]}"
fi