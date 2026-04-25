g++ -c start.cpp \
-ffreestanding \
-fno-exceptions \
-fno-rtti \
-nostdlib \
-fno-stack-protector \
-m64 \
-o start.o \
-std=gnu++20

g++ -ffreestanding -nostdlib -m64 \
./**/*.o \
-T linker.ld \
-o kernel.elf