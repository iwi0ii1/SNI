#include "framebuffer.hpp"

namespace bos {
    void framebuffer::fill(const uint32_t color) noexcept {
        if (!initialized)
            return;

        for (uint32_t y = 0; y < fb_cref.height; y++)
            for (uint32_t x = 0; x < fb_cref.width; x++)
                fb.addr[y * fb_cref.pitch + x] = color;
    }
}