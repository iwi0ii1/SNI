g++ -c framebuffer.cpp \
-ffreestanding \
-fno-exceptions \
-fno-rtti \
-nostdlib \
-fno-stack-protector \
-m64 \
-o display.o \
-std=gnu++20