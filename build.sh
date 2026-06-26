#!/bin/bash
set -e

name="sni"

cd kernel64
bash compile.sh
cd ../boot/load16
bash compile.sh
cd ../..

target_firmware="none"

if [[ "$1" == "bios" ]]; then
    printf "\nbuild.sh: $(pwd)\n[+] Assembling: boot/mbr.asm -> build/mbr.bin\n"
    nasm \
        -f bin \
        -I . \
        "boot/mbr.asm" -o "build/mbr.bin"

    # Build a disk image with those infos needed to run
    disk_img=build/disk.img
    disk_size=10M

    truncate -s $disk_size $disk_img # Generate a file with $disk_size of 0s
    dd if=build/mbr.bin of=$disk_img bs=512 seek=0 conv=notrunc status=none # Sector 1 (offs: 0x00)
    dd if=build/l16_main.bin of=$disk_img bs=512 seek=1 conv=notrunc status=none # Sector 2 (offs: 00x200)

    dd if=build/k64_load16_cfg.bin of=$disk_img bs=512 seek=2047 conv=notrunc status=none # Sector 2048 (offs: 0x100000)
    dd if=build/kernel64.bin of=$disk_img bs=512 seek=4096 conv=notrunc status=none # Sector 4096 (offs: 0x200000)

    target_firmware="BIOS"
fi

bool='n'

if [[ "$target_firmware" != "none" ]]; then
    printf "Run with $target_firmware? (y/n)"
    read bool
fi


if [[ "$bool" == "y" ]]; then
    if [[ "$target_firmware" == "BIOS" ]]; then
    qemu-system-x86_64 \
        -drive file=$disk_img,format=raw,index=0,media=disk \
        -machine pc-q35-2.4,accel=tcg,usb=off \
        -cpu qemu64,+nx \
        -rtc base=localtime,clock=vm,driftfix=slew \
        -m 128M \
        -boot c \
        -vga std \
        -serial stdio \
        -display gtk
    fi
fi