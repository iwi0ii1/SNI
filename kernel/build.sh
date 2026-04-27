#!/bin/bash
set -e

KERNEL_DIR="$(dirname "$0")"
BUILD_DIR="$KERNEL_DIR/build"
ISO_DIR="$KERNEL_DIR/../iso"
OUT="$BUILD_DIR/kernel.elf"

mkdir -p "$BUILD_DIR"

echo "[+] Compiling all .cpp files..."

SOURCES=$(find "$KERNEL_DIR" -name "*.cpp")

OBJS=""

for file in $SOURCES; do
    obj_name=$(echo "$file" | sed 's|/|_|g')
    obj="$BUILD_DIR/${obj_name%.cpp}.o"

    echo "[+] $file -> $obj"

    g++ -ffreestanding -O2 -c "$file" -o "$obj"

    OBJS="$OBJS $obj"
done

echo "[+] Linking kernel..."

ld -T "$KERNEL_DIR/linker.ld" -o "$OUT" $OBJS

echo "[+] Copying to ISO..."
cp "$OUT" "$ISO_DIR/boot/kernel.elf"

echo "[✓] Build complete"