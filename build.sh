#!bin/bash
set -e

rm -rf kernel/build
rm -rf iso/boot/kernel.elf



#region Build kernel

KERNEL_DIR="kernel"
BUILD_DIR="$KERNEL_DIR/build"
ISO_DIR="iso"
OUT="$BUILD_DIR/kernel.elf"

mkdir -p "$BUILD_DIR"

if [[ "$1" == "nocompile" ]]; then
    OBJS=()
    echo "[+] Linking kernel..."
    ld -nostdlib -m elf_x86_64 -T "$KERNEL_DIR/linker.ld" -o "$OUT" "${OBJS[@]}"

else
    echo "[+] Compiling all .cpp files..."

    SOURCES=$(find "$KERNEL_DIR" -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" \))

    OBJS=()

    while IFS= read -r file; do
        rel="${file#$KERNEL_DIR/}"
        obj="$BUILD_DIR/${rel}.o"
        obj="${obj//\//_}"

        echo "[+] $file -> $obj"

        case "$file" in
            *.cpp)
                g++ -ffreestanding -nostdlib -fno-exceptions -fno-rtti -O2 -m64 \
                    -c "$file" -o "$obj"
                ;;
        
            *.c)
                gcc -ffreestanding -nostdlib -O2 -m64 \
                    -c "$file" -o "$obj"
                ;;
        
            *.asm)
                nasm -f elf64 "$file" -o "$obj"
                ;;
        
            *)
                echo "[-] Unknown file type: $file"
                exit 1
                ;;
        esac

        OBJS+=("$obj")
    done <<< "$SOURCES"

    echo "[+] Linking kernel..."

    ld -nostdlib -m elf_x86_64 -T "$KERNEL_DIR/linker.ld" -o "$OUT" "${OBJS[@]}"
fi

echo "[+] Copying to ISO..."
cp "$OUT" "$ISO_DIR/boot/kernel.elf"

echo "[✓] Build complete"

#endregion Build kernel



rm -rf iso/boot/kernel.elf
mv kernel/build/kernel.elf iso/boot

grub-mkrescue -o whiteos.iso iso/

if [[ "$1" == "run" ]]; then
    qemu-system-x86_64 -cdrom whiteos.iso -display gtk
fi