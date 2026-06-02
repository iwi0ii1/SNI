#!/bin/bash
set -e

kernel_name="sni"

rm -rf kernel/build
rm -rf iso/boot/kernel.elf


mkdir -p "kernel/build"

cd kernel
pwd
bash compile.sh
cd ..

printf "\n[+] Copying to ISO..."

rm -rf iso/boot/kernel.elf
mv kernel/build/kernel.elf iso/boot

printf "\n[✓] Build complete"



grub-mkrescue -o "$kernel_name.iso" iso/

if [[ "$1" == "run" ]]; then
    qemu-system-x86_64 -cdrom "$kernel_name.iso" -display gtk -machine q35
fi