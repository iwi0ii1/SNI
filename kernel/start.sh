g++ -c start.cpp \
-ffreestanding \
-fno-exceptions \
-fno-rtti \
-nostdlib \
-fno-stack-protector \
-m64 \
-o start.o \
-std=gnu++20

set +f # Enable globbing (the star thingy)

g++ -ffreestanding -nostdlib -m64 \
start.o \
./**/*.o \
-T linker.ld \
-o kernel.elf

mv kernel.elf ../iso/boot