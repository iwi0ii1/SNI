#include "display/framebuffer.hpp"



/**
 * @brief Where the kernel starts.
 */
extern "C"
void _start() noexcept {
    uint64_t magic;
    void* info;

    // Hell naw, we writing inline assembly??
    asm volatile (
        "mov %%rax, %0\n"
        "mov %%rbx, %1\n"
        : "=m"(magic), "=m"(info)
        :
        : "rax", "rbx"
    );
    
    volatile uint16_t* vga = reinterpret_cast<uint16_t*>(0xB8000);
    vga[0] = 0x4F58; // red 'X'
    vga[1] = 0x4F59; // red 'Y'
    vga[2] = 0x4F5A; // red 'Z'

    /*
    bos::boot::init(magic, info);
    bos::framebuffer::init(bos::boot::get_framebuffer());

    bos::framebuffer::fill(0x00FF0000); // XRGB?
    */

    while (1)
        asm("hlt");
}