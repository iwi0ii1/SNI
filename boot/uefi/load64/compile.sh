#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)"

build_loc="../../../build/uefi/load64"

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling 64-bit loader.\n"

for file in "${SOURCES[@]}"; do
    file="${file#./}"
    newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.o/')"

    case "$file" in
        *.cpp)
            printf "[+] Compiling $file -> $newpath\n"
            : '
            g++ \
                -ffreestanding -nostdlib -nostartfiles \
                -O0 -m64 \
                -mno-red-zone \
                -msoft-float \
                -mno-avx -mno-avx2 \
                -fno-stack-protector -fno-stack-check -fno-strict-aliasing \
                -fno-omit-frame-pointer -fno-builtin -fPIC -fno-pie -no-pie \
                -static \
                -std=c++23 \
                -fno-exceptions \
                -fno-rtti \
                -I . \
                -g \
                -c "${file#./}" -o "$newpath"'
                
            g++ \
                -m64 -fPIC -mno-red-zone -fshort-wchar \
                -msoft-float \
                -fno-stack-protector -fno-builtin \
                -fno-exceptions -fno-rtti \
                -O0 -g \
                -I . \
                -c "${file#./}" -o "$newpath"
            ;;
        
        *.c)
            printf "[+] Compiling: $file -> $newpath\n"
            : '
            gcc \
                -ffreestanding -nostdlib -nostartfiles \
                -O0 -m64 \
                -mno-red-zone \
                -msoft-float \
                -mno-avx -mno-avx2 \
                -fno-stack-protector -fno-stack-check -fno-strict-aliasing \
                -fno-omit-frame-pointer -fno-builtin -fPIC -fno-pie -no-pie \
                -static \
                -std=c2x \
                -I . \
                -g \
                -c "${file#./}" -o "$newpath"'
            gcc \
                -m64 -fPIC -mno-red-zone -fshort-wchar \
                -msoft-float \
                -fno-stack-protector -fno-builtin \
                -O0 -g \
                -I . \
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

EFI_LDS=$(find /usr -name "elf_x86_64_efi.lds" 2>/dev/null | head -n 1)

ld \
    -nostdlib \
    -znocombreloc \
    -T "$EFI_LDS" \
    -shared \
    -Bsymbolic \
    -o "$build_loc/main.so" \
    "$build_loc"/*.o \
    -L/usr/lib \
    -lefi -lgnuefi

printf "\nCreating EFI binary...\n"

objcopy \
    -j .text \
    -j .sdata \
    -j .data \
    -j .dynamic \
    -j .dynsym \
    -j .rel \
    -j .rela \
    -j .reloc \
    --target=efi-app-x86_64 \
    "$build_loc/main.so" \
    "$build_loc/BOOTX64.EFI"

mkdir -p "$build_loc/EFI/BOOT"
cp "$build_loc/BOOTX64.EFI" "$build_loc/EFI/BOOT/BOOTX64.EFI"