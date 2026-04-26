#include "display/framebuffer.hpp"



/**
 * @brief Where the kernel starts.
 */
extern "C"
void _start(uint64_t magic, void* info) noexcept {
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

    while (1)
        asm("hlt");
}