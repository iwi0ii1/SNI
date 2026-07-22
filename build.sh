#!/bin/bash
set -e

name="sni"

bios_disk_img=build/bios/disk.img
bios_disk_size=10M

uefi_disk_img=build/uefi/disk.img
uefi_disk_size=10M

build () {
    if [[ "$1" == "bios" ]]; then
        mkdir -p "build/bios/" && find "build/bios" -mindepth 1 -delete # emptying build/bios

        cd kernel ; bash compile.sh bios ; \
        cd ../loader ; bash compile.sh bios ; cd ..

        truncate -s $bios_disk_size $bios_disk_img # Generate a file with $disk_size of 0s

        # Write [Loader stages]
        dd if=build/bios/loader/loader.bin of=$bios_disk_img bs=512 seek=0 conv=notrunc status=none # Sector 0 (mem offs: 0x00)

        # Write [Kernel]
        dd if=build/bios/kernel/kernel.bin of=$bios_disk_img bs=512 seek=2048 conv=notrunc status=none # Sector 2048 (mem offs: 0x100000 = 1MiB)

        # Write [Kernel's default boot entry for loader]
        cat > build/bios/dflt_krnl_bootentry.asm <<'EOF'
            section .rodata
            times 510 db 0x00
            
            dw 0xABCD
EOF
        nasm -f bin "build/bios/dflt_krnl_bootentry.asm" -o "build/bios/dflt_krnl_bootentry.bin" -dKRNL_LBA_COUNT=$(( ( $(stat -c%s build/bios/kernel/kernel.bin) + 511 ) / 512 ))
        dd if=build/bios/dflt_krnl_bootentry.bin of=$bios_disk_img bs=512 seek=3 conv=notrunc # Sector 3 (mem offs: 0x8200)

    elif [[ "$1" == "uefi" ]]; then
        mkdir -p "build/uefi" && find "build/uefi" -mindepth 1 -delete # emptying build/uefi

        cd kernel ; bash compile.sh uefi && \
        cd ../boot/uefi/load64 ; bash compile.sh && cd ../../..

        truncate -s $uefi_disk_size $uefi_disk_img # Generate a file with $disk_size of 0s

        # Write [Kernel]
        dd if=build/uefi/kernel/kernel.elf of=$uefi_disk_img bs=512 seek=2048 conv=notrunc status=none # Sector 2048 (offs: 0x100000 = 1MiB)

    else
        printf "Build BIOS or UEFI??? Try again, cuh."
        exit 1
    fi
}

run () {
    if [[ "$1" == "bios" ]]; then
        if [[ "$2" == "dbg" ]]; then
            qemu-system-x86_64 \
                -drive file=$bios_disk_img,format=raw,index=0,media=disk \
                -machine pc-q35-2.4,accel=tcg,usb=off \
                -cpu qemu64,+nx \
                -rtc base=localtime,clock=vm,driftfix=slew \
                -m 128M \
                -boot c \
                -vga std \
                -display gtk \
                -monitor stdio \
                -s -S
        else
            qemu-system-x86_64 \
                -drive file=$bios_disk_img,format=raw,index=0,media=disk \
                -machine pc-q35-2.4,accel=tcg,usb=off \
                -cpu qemu64,+nx \
                -rtc base=localtime,clock=vm,driftfix=slew \
                -m 128M \
                -boot c \
                -vga std \
                -display gtk \
                -monitor stdio
        fi
    elif [[ "$1" == "uefi" ]]; then
        if [[ "$2" == "dbg" ]]; then
            qemu-system-x86_64 \
                -drive file=$uefi_disk_img,format=raw,index=0,media=disk \
                -machine pc-q35-2.4,accel=tcg,usb=off \
                -cpu qemu64,+nx \
                -rtc base=localtime,clock=vm,driftfix=slew \
                -m 128M \
                -bios /usr/share/ovmf/OVMF.fd \
                -vga std \
                -display gtk \
                -monitor stdio \
                -s -S
        else
            qemu-system-x86_64 \
                -drive file=$uefi_disk_img,format=raw,index=0,media=disk \
                -machine pc-q35-2.4,accel=tcg,usb=off \
                -cpu qemu64,+nx \
                -rtc base=localtime,clock=vm,driftfix=slew \
                -m 128M \
                -bios /usr/share/ovmf/OVMF.fd \
                -vga std \
                -display gtk \
                -monitor stdio
        fi
    else
        printf "Run BIOS or UEFI??? Try again, cuh."
        exit 1
    fi
}

[[ "$2" == "bios" || "$2" == "uefi" ]] && common_bool=true || common_bool=false # Yeah, Bash can't handle simple things like assigning the result of ops to a variable without being dirty

if [[ "$1" == "build" && common_bool -eq true ]]; then
    build "$2"
elif [[ "$1" == "run" && common_bool -eq true ]]; then
    run "$2"
elif [[ "$1" == "rundbg" && common_bool -eq true ]]; then
    run "$2" "dbg"
elif [[ "$1" == "buildrun" && common_bool -eq true ]]; then
    build "$2"
    run "$2"
elif [[ "$1" == "buildrundbg" && common_bool -eq true ]]; then
    build "$2"
    run "$2" "dbg"
else
    printf "U wanna build, run, or both (buildrun)??? Try again, cuh."
    exit 1
fi