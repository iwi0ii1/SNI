#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)"

if [[ "$1" == "bios" || "$1" == "uefi" ]]; then
    build_loc="../../build/$1/loader"
else
    build_loc="../../build/unknown/loader"
fi

rm -rf "$build_loc"
mkdir -p "$build_loc"

mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
printf "\nCompiling loader."

for file in "${SOURCES[@]}"; do
    file="${file#./}"
    newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.bin/')"

    case "$file" in
        *.asm)
            printf "[+] Assembling: $file -> $newpath\n"
            nasm \
                -f bin \
                -I . \
                "${file#./}" -o "$newpath" \
            ;;
        
        *)
            printf "[-] Unknown file type: $file"
            exit 1
            ;;
    esac
done