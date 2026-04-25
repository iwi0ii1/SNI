#include "display/framebuffer.hpp"



/**
 * @brief Where the kernel starts.
 */
extern "C"
void _start(const uint32_t magic, const uint64_t info) noexcept {
    bos::framebuffer::init(info);
    while (1)
        asm("hlt");
}