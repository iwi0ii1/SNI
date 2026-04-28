#include "display/framebuffer.hpp"


/**
 * @brief Where the kernel starts
 */
extern "C"
void main(const uint64_t magic, const void* info) noexcept {
    if (magic != bos::MULTIBOOT2_MAGIC) {
        volatile uint16_t* vga = (uint16_t*)0xB8000;
        vga[0] = 0x4F4D; // 'M'
        while (1) asm("hlt");
    }

    if (!info) {
        volatile uint16_t* vga = (uint16_t*)0xB8000;
        vga[1] = 0x4F49; // 'I'
        while (1) asm("hlt");
    }

    bos::vga::write_str("Hello world!!", 14);
}



/**
 * @brief Just calls the kernel.
 */
extern "C" [[noreturn]] void _start() {
    volatile uint16_t* vga = (uint16_t*)0xB8000;
    vga[0] = 0x4F4D; // 'M'

    uint64_t magic;
    void* info;

    asm volatile(
        "mov %%rdi, %0\n"
        "mov %%rsi, %1\n"
        : "=r"(magic), "=r"(info)
        :
        : "rdi", "rsi"
    );

    main(magic, info);

    for (;;) asm("hlt");
}