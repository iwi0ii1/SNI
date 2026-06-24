#!/bin/bash
set -e

name="sni"

cd kernel64
bash compile.sh
cd ../launchers/launch16
bash compile.sh
cd ../launch64
bash compile.sh
cd ../..

target_firmware="none"

printf "\n[+] Linking...\n"
if [[ "$1" == "bios" ]]; then
    test_loc="tests/bios"

    # ELF64
    ld -nostdlib -m elf_x86_64 -T "$test_loc/bios_linker.ld" -o "$test_loc/$name.elf" --nmagic \
    build/launch16.o build/kernel64.o \
    -z noexecstack # Don't assume stack is executable

    # Raw binary
    objcopy -I elf64-x86-64 -O binary "$test_loc/$name.elf" "$test_loc/$name.bin"

    target_firmware="BIOS"
fi

bool='n'

if [[ "$target_firmware" != "none" ]]; then
    printf "Run with $target_firmware? (y/n)"
    read bool
fi


if [[ "$bool" == "y" ]]; then
    if [[ "$target_firmware" == "BIOS" ]]; then
        qemu-system-x86_64 -drive format=raw,file=$test_loc/$name.bin
    fi
fi