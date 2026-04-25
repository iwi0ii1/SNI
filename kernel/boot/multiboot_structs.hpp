#include <cstdint>

struct multiboot_tag {
    uint32_t type;
    uint32_t size;
};

struct multiboot_tag_framebuffer {
    uint32_t type;
    uint32_t size;

    uint64_t address;
    uint32_t pitch;
    uint32_t width;
    uint32_t height;
    uint8_t  bpp;
    uint8_t  type2;
    uint16_t reserved;
};

#define MULTIBOOT_TAG_TYPE_FRAMEBUFFER 8