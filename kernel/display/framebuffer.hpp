#pragma once
#include "../boot/multiboot_structs.hpp"


namespace bos {
    /**
     * @brief Framebuffer static class
     */
    class framebuffer final {
    private:
        static inline uint32_t* fb = nullptr;
        static inline uint32_t width = 0;
        static inline uint32_t height = 0;
        static inline uint32_t pitch = 0;

    public:
        inline static void init(const uint64_t info) noexcept {
            if (fb)
                return;

            auto* tag = static_cast<multiboot_tag*>(info);

            while (tag->type != 0) {
                if (tag->type == MULTIBOOT_TAG_TYPE_FRAMEBUFFER) {
                    auto* f = (multiboot_tag_framebuffer*)tag;

                    if (f->bpp != 32)
                        return;

                    fb = (uint32_t*)f->address;
                    width = f->width;
                    height = f->height;
                    pitch = f->pitch / 4;
                    return;
                }

                tag = static_cast<multiboot_tag*>(static_cast<uint8_t*>(tag) + ((tag->size + 7) & ~7));
            }
        }

        static void put_pixel(uint32_t x, uint32_t y, uint32_t color) {
            if (!fb || x >= width || y >= height)
                return;
            fb[y * pitch + x] = color;
        }

        static void clear(uint32_t color) {
            if (!fb)
                return;

            for (uint32_t i = 0; i < width * height; i++)
                fb[i] = color;
        }

        static uint32_t get_width() { return width; }
        static uint32_t get_height() { return height; }
    };
}