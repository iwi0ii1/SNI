#!/bin/bash
set -e

name="sni"
target_firmware="none"

if [[ "$1" == "bios" ]]; then
    cd kernel64 ; bash compile.sh bios ; \
    cd ../boot/bios/load32 ; bash compile.sh ; cd ../../..

    printf "\nbuild.sh: $(pwd)\n[+] Assembling: boot/bios/mbr.asm -> build/bios/mbr.bin\n"
    # Assembling raw MBR
    nasm \
        -f bin \
        -I . \
        "boot/bios/mbr.asm" -o "build/bios/mbr.bin"

    # Building a disk image
    disk_img=build/bios/disk.img
    disk_size=10M

    truncate -s $disk_size $disk_img # Generate a file with $disk_size of 0s

    # Write [MBR] and [Load32]
    dd if=build/bios/mbr.bin of=$disk_img bs=512 seek=0 conv=notrunc status=none # Sector 1 (offs: 0x00)
    dd if=build/bios/load32/load32.bin of=$disk_img bs=512 seek=1 conv=notrunc status=none # Sector 2 (offs: 0x200)

    # Write [Kernel64] and [Kernel64 Config for Load32]
    dd if=build/bios/kernel64/k64_load32_cfg.bin of=$disk_img bs=512 seek=2047 conv=notrunc status=none # Sector 2048 (offs: 0x100000)
    dd if=build/bios/kernel64/kernel64.bin of=$disk_img bs=512 seek=4096 conv=notrunc status=none # Sector 4096 (offs: 0x200000)

    target_firmware="BIOS"
elif [[ "$1" == "uefi" ]]; then
    cd kernel64 ; bash compile.sh uefi && \
    cd ../boot/uefi/load64 ; bash compile.sh && cd ../../..

    # Building a disk image
    disk_img=build/uefi/disk.img
    disk_size=10M

    truncate -s $disk_size $disk_img # Generate a file with $disk_size of 0s

    # Write [Kernel64]
    dd if=build/uefi/kernel64/kernel64.elf of=$disk_img bs=512 seek=4096 conv=notrunc status=none # Sector 4096 (offs: 0x200000)

    target_firmware="UEFI"
else
    printf "\"\$1\" must be \"bios\" or \"uefi\"!!"
    exit 1
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
    elif [[ "$target_firmware" == "UEFI" ]]; then
        qemu-system-x86_64 \
            -drive file=$disk_img,format=raw,index=0,media=disk \
            -machine pc-q35-2.4,accel=tcg,usb=off \
            -cpu qemu64,+nx \
            -rtc base=localtime,clock=vm,driftfix=slew \
            -m 128M \
            -bios /usr/share/ovmf/OVMF.fd \
            -vga std \
            -serial stdio \
            -display gtk
    fi
fi