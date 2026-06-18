#!/bin/bash
set -e

kernel_name="sni"

cd kernel
bash compile.sh
cd ..

if [[ "$1" == "run-bios" ]]; then
    qemu-system-x86_64 -drive format=raw,file=sni.bin
fi