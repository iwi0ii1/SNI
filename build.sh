#!/bin/bash
set -e

name="sni"

cd core/kernel64
bash compile.sh
cd ../raw16
bash compile.sh
cd ../..

target_firmware="none"

printf "\n[+] Linking kernel\n"
if [[ "$1" == "bios" ]]; then
    ld -nostdlib -T "tests/bios/bios_linker.ld" -o "tests/bios/$name.bin" \
    build/raw16/*.o build/kernel64/*.o \
    build/launch16/*.o build/launch64/*.o \
    -z noexecstack # Don't assume stack is executable
    target_firmware="BIOS"
fi


printf "Run with $target_firmware? (y/n)"
read bool


if [[ "$bool" == "y" ]]; then
    if [[ "$target_firmware" == "BIOS" ]]; then
        cd tests/bios
        qemu-system-x86_64 -drive format=raw,file=$name.bin
        cd ../..
    fi
fi