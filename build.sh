#!/bin/bash
set -e

name="sni"

cd core/kernel64
bash compile.sh
cd ../raw16
bash compile.sh
cd ../../launchers/launch16
bash compile.sh
cd ../launch64
bash compile.sh
cd ../..

target_firmware="none"

printf "\n[+] Linking...\n"
if [[ "$1" == "bios" ]]; then
    test_loc="tests/bios"

    # Raw executable
    ld -nostdlib -T "tests/bios/bios_linker.ld" -o "$test_loc/$name.bin" \
    build/raw16.o build/kernel64.o build/launch16.o \
    -z noexecstack # Don't assume stack is executable

    # ELF64 binary for debugging
    objcopy -I binary -O elf64-x86-64 "$test_loc/$name.bin" "$test_loc/$name.elf"

    target_firmware="BIOS"
fi

bool='n'

if [[ "$target_firmware" != "none" ]]; then
    printf "Run with $target_firmware? (y/n)"
    read bool
fi


if [[ "$bool" == "y" ]]; then
    if [[ "$target_firmware" == "BIOS" ]]; then
        cd tests/bios
        qemu-system-x86_64 -drive format=raw,file=$name.bin
        cd ../..
    fi
fi