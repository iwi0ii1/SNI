#!/bin/bash
set -e

printf "compile.sh: $(pwd)\n"

build_loc="../build/kernel64"

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling 64-bit build.\n"

for file in "${SOURCES[@]}"; do
    file="${file#./}"
    newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.o/')"

    case "$file" in
        *.cpp)
            printf "[+] Compiling $file -> $newpath\n"
            g++ \
                -ffreestanding -nostdlib -nostartfiles \
                -O0 -m64 \
                -mno-red-zone \
                -msoft-float \
                -mno-avx -mno-avx2 \
                -fno-stack-protector -fno-stack-check -fno-strict-aliasing \
                -fno-omit-frame-pointer -fno-builtin -fno-pic -fno-pie -no-pie \
                -static \
                -std=c++23 \
                -fno-exceptions \
                -fno-rtti \
                -I . \
                -g \
                -c "${file#./}" -o "$newpath"
            ;;
        
        *.c)
            printf "[+] Compiling: $file -> $newpath\n"
            gcc \
                -ffreestanding -nostdlib -nostartfiles \
                -O0 -m64 \
                -mno-red-zone \
                -msoft-float \
                -mno-avx -mno-avx2 \
                -fno-stack-protector -fno-stack-check -fno-strict-aliasing \
                -fno-omit-frame-pointer -fno-builtin -fno-pic -fno-pie -no-pie \
                -static \
                -std=c2x \
                -I . \
                -g \
                -c "${file#./}" -o "$newpath"
            ;;

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

ld -r -nostdlib -m elf_x86_64 $build_loc/*.o -o $build_loc/../kernel64.o -z noexecstack
rm -rf $build_loc