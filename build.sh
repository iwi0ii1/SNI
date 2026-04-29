#!/bin/bash
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
    printf "[+] Linking kernel...\n"
    ld -nostdlib -m elf_x86_64 -T "$KERNEL_DIR/linker.ld" -o "$OUT" "${OBJS[@]}"

else
    printf "[+] Compiling all .cpp files..."

    SOURCES=$(find "$KERNEL_DIR" -type f \( -name "*.cpp" -o -name "*.c" -o -name "*.asm" \) -print)

    OBJS=()

    while IFS= read -r file; do
        obj="$(realpath --relative-to="$KERNEL_DIR" "$file")/${rel}.o"
        obj="$BUILD_DIR/${obj//\//_}"


        case "$file" in
            *.cpp)
                printf "\n[+] compiling: $file -> $obj"
                g++ -ffreestanding -nostdlib -fno-exceptions -fno-rtti -O0 -m64 \
                    -c "$file" -o "$obj"
                ;;
        
            *.c)
                printf "\n[+] compiling: $file -> $obj"
                gcc -ffreestanding -nostdlib -O0 -m64 \
                    -c "$file" -o "$obj"
                ;;
        
            *.asm)
                printf "\n[+] assembling: $file -> $obj"
                nasm -f elf64 "$file" -o "$obj"
                ;;
        
            *)
                printf "[-] Unknown file type: $file"
                exit 1
                ;;
        esac

        OBJS+=("$obj")
    done <<< "$SOURCES"

    printf "\n[+] Linking kernel...\n"

    ld -nostdlib -m elf_x86_64 -T "$KERNEL_DIR/linker.ld" -o "$OUT" "${OBJS[@]}"
fi

printf "\n[+] Copying to ISO..."
cp "$OUT" "$ISO_DIR/boot/kernel.elf"

printf "\n[✓] Build complete"

#endregion Build kernel



rm -rf iso/boot/kernel.elf
mv kernel/build/kernel.elf iso/boot

grub-mkrescue -o whiteos.iso iso/

if [[ "$1" == "run" ]]; then
    qemu-system-x86_64 -cdrom whiteos.iso -display gtk
fi