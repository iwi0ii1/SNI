#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)"

build_loc="../build/load16"

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling 16-bit build.\n"

for file in "${SOURCES[@]}"; do
    file="${file#./}"
    newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.o/')"

    case "$file" in
        l16_mbr.asm)
            printf "[+] Assembling: $file -> $newpath\n"
            nasm \
            -f bin \
            -I . \
            "${file#./}" -o "$build_loc/../l16_mbr.bin" \
            ;;

        *.asm)
            printf "[+] Assembling: $file -> $newpath\n"
            nasm \
            -f elf32 \
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

ld -nostdlib -m elf_i386 -T linker.ld $build_loc/*.o -o $build_loc/../l16_main.bin -z noexecstack --nmagic
rm -rf $build_loc