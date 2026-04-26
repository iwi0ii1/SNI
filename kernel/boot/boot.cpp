#include "boot.hpp"


__attribute__((section(".multiboot"), aligned(8)))
const unsigned int mb2_header[] = {
    0xE85250D6,  // magic
    0x0,         // architecture
    24,          // header length
    -(0xE85250D6 + 0 + 24),

    0,           // end tag type (short, but padded)
    8            // end tag size
};


template<typename T>
T read(const uint8_t* p, uint32_t offset) {
    T out = {};
    uint8_t* dst = reinterpret_cast<uint8_t*>(&out);

    for (size_t i = 0; i < sizeof(T); i++)
        dst[i] = *(p + offset + i);

    return out;
}


namespace bos {
    #pragma region Definitions
    const tag_header_t* boot::find(const info_type type) noexcept {
        if (!base || !initialized)
            return nullptr;

        const uint8_t* ptr = base + 8;

        const uint32_t itype = static_cast<uint32_t>(type);

        while (ptr < base + total) {
            const tag_header_t* tag = reinterpret_cast<const tag_header_t*>(ptr);

            if (tag->type == 0 || tag->size < 8)
                break;
            else if (tag->type == itype)
                return tag;
                

            ptr += (tag->size + 7) & ~7;
        }

        return nullptr;
    }
    


    boot::framebuffer_t boot::get_framebuffer() noexcept {
        if (!base || !initialized)
            return {};

        framebuffer_t out = {};

        auto* tag = find(info_type::framebuffer);
        if (!tag)
            return {};

        const uint8_t* data = reinterpret_cast<const uint8_t*>(tag);

        uint64_t addr = read<uint64_t>(data, 8);
        uint32_t width = read<uint32_t>(data, 16);
        uint32_t height = read<uint32_t>(data, 20);
        uint32_t pitch = read<uint32_t>(data, 24);
        uint8_t bpp = read<uint8_t>(data, 32);

        if (bpp != 32 || data[FB_TYPE_OFFSET] != FB_TYPE_RGB)
            return out;

        out.addr = reinterpret_cast<uint32_t*>(addr);
        out.width = width;
        out.height = height;
        out.pitch = pitch / 4;
        out.bpp = bpp;

        return out;
    }



    boot::memory_map_t boot::get_memory_map() noexcept {
        if (!base || !initialized)
            return {};

    }


    
    boot::modules_t boot::get_modules() noexcept {
        if (!base || !initialized)
            return {};

    }
    #pragma endregion Definitions
}