#!/bin/bash
set -e



if [[ $# -eq 0 ]]; then
    args=("$@")

    mkdir -p build
    
    mapfile -t SOURCES < <(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \))
    
    OBJS=()

    for file in "${SOURCES[@]}"; do
        file="${file#./}"
        newpath="build/$(echo "$file" | sed 's/\//_/g')"

        case "$file" in
            *.cpp)
                printf "[+] Compiling $file -> $newpath\n"
                g++ \
                    -ffreestanding \
                    -nostdlib \
                    -nostartfiles \
                    -fno-exceptions \
                    -fno-rtti \
                    -O0 \
                    -g \
                    -m64 \
                    -mno-red-zone \
                    -fno-stack-protector \
                    -fno-strict-aliasing \
                    -fno-omit-frame-pointer \
                    -fno-builtin \
                    -fno-stack-check \
                    -fno-pic \
                    -std=c++23 \
                    -D${1:-BOOT_PROTOCOL_MB2} \
                    -c "${file#./}" -o "$newpath"
                ;;
        
            *.c)
                printf "[+] Compiling: $file -> $newpath\n"
                gcc \
                    -ffreestanding \
                    -nostdlib \
                    -nostartfiles \
                    -O0 \
                    -g \
                    -m64 \
                    -mno-red-zone \
                    -fno-stack-protector \
                    -fno-strict-aliasing \
                    -fno-omit-frame-pointer \
                    -fno-builtin \
                    -fno-stack-check \
                    -fno-pic \
                    -std=c2x \
                    -D${1:-BOOT_PROTOCOL_MB2} \
                    -c "${file#./}" -o "$newpath"
                ;;

            *.asm)
                printf "[+] Assembling: $file -> $newpath\n"
                nasm \
                -f elf64 \
                -g \
                -F dwarf \
                -D${1:-BOOT_PROTOCOL_MB2} \
                "${file#./}" -o "$newpath" \
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
fi