#!/bin/bash
set -e

kernel_name="sni"

rm -rf kernel/build
rm -rf iso/boot/$kernel_name.elf


mkdir -p "kernel/build"

cd kernel
bash compile.sh
cd ..

printf "\n[+] Copying to ISO..."

rm -rf iso/boot/$kernel_name.elf
mv kernel/build/$kernel_name.elf iso/boot

printf "\n[✓] Build complete"




if [[ "$1" == "run-grub" ]]; then # Run by GRUB
    grub-mkrescue -o "grub-$kernel_name.iso" iso/ && \
    qemu-system-x86_64 -cdrom "grub-$kernel_name.iso" -display gtk -machine q35
fi