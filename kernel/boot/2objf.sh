g++ -c boot.cpp \
-ffreestanding \
-fno-exceptions \
-fno-rtti \
-nostdlib \
-fno-stack-protector \
-m64 \
-o boot.o \
-std=gnu++20