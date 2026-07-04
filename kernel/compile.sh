#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)"

if [[ "$1" == "bios" || "$1" == "uefi" ]]; then
    build_loc="../build/$1/kernel"
else
    build_loc="../build/unknown/kernel"
fi

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling 64-bit kernel."

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

if [[ "$1" == "bios" ]]; then
    ld -nostdlib --oformat binary -T linker.ld $build_loc/*.o -o $build_loc/kernel.bin -z noexecstack --nmagic
elif [[ "$1" == "uefi" ]]; then
    ld -nostdlib -m elf_x86_64 -T linker.ld $build_loc/*.o -o $build_loc/kernel.elf -z noexecstack --nmagic
fi