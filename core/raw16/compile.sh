#!/bin/bash
set -e

printf "compile.sh: $(pwd)\n"

build_loc="../../build/raw16"

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling 16-bit build.\n"

for file in "${SOURCES[@]}"; do
    file="${file#./}"
    newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.o/')"

    case "$file" in
        *.asm)
            printf "[+] Assembling: $file -> $newpath\n"
            nasm \
            -f elf64 \
            -g \
            -F dwarf \
            -I . \
            "${file#./}" -o "$newpath" \
            ;;
        
        *)
            printf "[-] Unknown file type: $file"
            exit 1
            ;;
    esac
done