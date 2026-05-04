#!/bin/bash
set -e



if [[ $# -eq 0 ]]; then
    args=("$@")

    mkdir -p build
    
    mapfile -t SOURCES < <(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \))
    
    OBJS=()

    for file in "${SOURCES[@]}"; do
        newpath="build/$(echo "$file" | sed 's/\//_/g')"

        case "$file" in
            *.cpp)
                printf "[+] Compiling $file -> $newpath\n"
                g++ -ffreestanding -nostdlib -fno-exceptions -fno-rtti -O0 -m64 \
                    -c "$file" -o "$newpath"
                ;;
        
            *.c)
                printf "[+] compiling: $file -> $newpath\n"
                gcc -ffreestanding -nostdlib -O0 -m64 \
                    -c "$file" -o "$newpath"
                ;;
        
            *.asm)
                printf "[+] assembling: $file -> $newpath\n"
                nasm -f elf64 "$file" -o "$newpath"
                ;;
        
            *)
                printf "[-] Unknown file type: $file"
                exit 1
                ;;
        esac

        OBJS+=("$newpath")
    done

    printf "\n[+] Linking kernel...\n"

    ld -nostdlib -m elf_x86_64 -T "linker.ld" -o "build/kernel.elf" "${OBJS[@]}"
else
    newpath=$(echo "$1" | sed 's/\//_/g')

    case "$1" in
        *.cpp)
            printf "[+] Compiling $file -> $newpath\n"
            g++ -ffreestanding -nostdlib -fno-exceptions -fno-rtti -O0 -m64 \
                -c "$file" -o "$newpath"
            ;;
        
        *.c)
            printf "[+] compiling: $file -> $newpath\n"
            gcc -ffreestanding -nostdlib -O0 -m64 \
                -c "$file" -o "$newpath"
            ;;
        
        *.asm)
            printf "[+] assembling: $file -> $newpath\n"
            nasm -f elf64 "$file" -o "$newpath"
            ;;
        
        *)
            printf "[-] Unknown file type: $file"
            exit 1
            ;;
    esac
fi