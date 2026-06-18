#!/bin/bash
set -e

kernel_name="sni"

cd kernel
bash compile.sh $kernel_name # Will generate a build/ directory with *.o in there.
cd ..

target_firmware="none"

printf "\n[+] Linking kernel\n"
if [[ "$1" == "build-bios" ]]; then
    ld -nostdlib -T "bios_linker.ld" -o "$kernel_name.bin" build/*.o -z noexecstack # Don't assume stack is executable
    target_firmware="BIOS"
elif [[ "$1" == "build-uefi" ]]; then
    printf "Not supported yet"
    exit 1
fi


bool=0
if [[ "$2" != "run" ]]; then
    printf "Run with $target_firmware?"
    read bool
fi


if [[ $bool -eq 1 ]]; then
    printf "Run as BIOS?"
    read bool
    qemu-system-x86_64 -drive format=raw,file=$kernel_name.bin
elif [[ "$target_firmware" == "uefi" ]]; then
    printf "Not supported yet"
    exit 1
fi