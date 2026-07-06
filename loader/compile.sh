#!/bin/bash
set -e

printf "\ncompile.sh: $(pwd)\n"

if [[ "$1" == "bios" ]]; then
    build_loc="../build/$1/loader"

    rm -rf "$build_loc"
    mkdir -p "$build_loc"

    mapfile -t SOURCES < <(find . -type f \( -name "*.asm" -o -name "*.s" \))
    
    printf "\nCompiling 16-bit loader.\n"
    
    # for file in "${SOURCES[@]}"; do
        # file="${file#./}"
        # newpath="$build_loc/$(echo "$file" | sed 's/\//_/g' | sed 's/\.[^.]*$/.bin/')"

        # case "$file" in
            # *.asm)
                # printf "[+] Assembling: $file -> $newpath\n"
                # nasm \
                    # -f bin \
                    # -I . \
                    # "${file#./}" -o "$newpath" \
                # ;;
        
            # *)
                # printf "[-] Unknown file type: $file"
                # exit 1
                # ;;
        # esac
    # done

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