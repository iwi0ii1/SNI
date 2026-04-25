#include "display/framebuffer.hpp"



/**
 * @brief Where the kernel starts.
 */
extern "C"
void _start(const uint32_t magic, const void* info) noexcept {
    bos::boot::init(magic, info);
    bos::framebuffer::init(bos::boot::get_framebuffer());

    bos::framebuffer::fill(0x00FF0000); // XRGB?

    while (1)
        asm("hlt");
}