#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)\n"

if [[ "$1" == "bios" ]]; then
    build_loc="../build/$1/loader"

    rm -rf "$build_loc"
    mkdir -p "$build_loc"

    mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
    printf "\nCompiling 16-bit loader.\n"

    printf "[+] Assembling bios/ls_main.asm -> $build_loc/loader.bin\n"
    nasm -f bin -I . "bios/ls_main.asm" -o "$build_loc/loader.bin"

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