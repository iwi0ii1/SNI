#!/bin/bash
set -e

rm -rf kernel/build
rm -rf iso/boot/kernel.elf


mkdir -p "kernel/build"

cd kernel
bash compile.sh
cd ..

printf "\n[+] Copying to ISO..."

rm -rf iso/boot/kernel.elf
mv kernel/build/kernel.elf iso/boot

printf "\n[✓] Build complete"



grub-mkrescue -o whiteos.iso iso/

if [[ "$1" == "run" ]]; then
    qemu-system-x86_64 -cdrom whiteos.iso -display gtk
fi