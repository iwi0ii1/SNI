#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)\n"

if [[ "$1" == "bios" ]]; then
    build_loc="../build/$1/loader"

    rm -rf "$build_loc"
    mkdir -p "$build_loc"

    mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
    printf "\nCompiling 16-bit loader.\n"

    # Assembling
    printf "[+] Assembling bios/foundation.asm -> $build_loc/foundation.bin\n" ; nasm -f bin -I . "bios/foundation.asm" -o "$build_loc/foundation.bin"
    printf "[+] Assembling bios/collection.asm -> $build_loc/collection.bin\n" ; nasm -f bin -I . "bios/collection.asm" -o "$build_loc/collection.bin"
    printf "[+] Assembling bios/handoff.asm -> $build_loc/handoff.bin\n"       ; nasm -f bin -I . "bios/handoff.asm" -o "$build_loc/handoff.bin"

    # Concatenation
    cat "$build_loc/foundation.bin" "$build_loc/collection.bin" "$build_loc/handoff.bin" > "$build_loc/loader.bin"

elif [[ "$1" == "uefi" ]]; then
    build_loc="../build/$1/loader"

    rm -rf $build_loc
    mkdir -p "$build_loc"

    printf "UEFI not supported yet."
    exit 1
else
    printf "\"\$1\" must be \"bios\" or \"uefi\"!!"
    exit 1
fi