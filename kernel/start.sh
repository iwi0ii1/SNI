g++ -c start.cpp \
-ffreestanding \
-fno-exceptions \
-fno-rtti \
-nostdlib \
-fno-stack-protector \
-m64 \
-I../vendor/limine \
-o start.o \
-std=gnu++20