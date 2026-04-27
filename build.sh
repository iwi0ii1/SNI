#!bin/bash
set -e

bash kernel/build.sh kernel

rm -rf iso/boot/kernel.elf
mv kernel/build/kernel.elf iso/boot

grub-mkrescue -o whiteos.iso iso/

qemu-system-x86_64 -cdrom whiteos.iso -nographic -serial mon:stdio