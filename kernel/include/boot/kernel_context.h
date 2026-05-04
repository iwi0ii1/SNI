#pragma once
#include <stdint.h>

struct kernel_context_t {
    // framebuffer (from boot)
    uint32_t* fb_addr;
    uint32_t fb_width;
    uint32_t fb_height;
    uint32_t fb_pitch;
    uint8_t  fb_bpp;

    // boot metadata
    uint32_t magic;
    void* mb_addr;
};