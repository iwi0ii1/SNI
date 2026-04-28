#pragma once
#include "../boot/boot.hpp"

namespace bos {
    /**
     * @brief Framebuffer static class
     */
    class framebuffer final {
    private:
        inline static bool initialized = false;
        inline static boot::framebuffer_t fb;

    public:
        /**
         * @brief Initialize framebuffer manager.
         */
        inline static void init(const boot::framebuffer_t& info) noexcept {
            if (initialized)
                return;

            fb = info;
            initialized = true;
        }

        /**
         * @brief Get framebuffer info
         */
        inline static decltype(fb) get_framebuffer() noexcept { return fb; }

        /**
         * @brief Set a specific pixel to a color (hexal)
         */
        inline static void put_pixel(const uint32_t x, const uint32_t y, const uint32_t color) noexcept {
            if (
                !initialized
                 || x >= get_framebuffer().width
                 || y >= get_framebuffer().height
            ) return;

            fb.addr[y * get_framebuffer().pitch + x] = color;
        }

        /**
         * @brief Fill the entire screen with a color (hexal, defaults to white)
         * @note Might be slow in some cases
         */
        inline static void fill(const uint32_t color = 0x00FFFFFF) noexcept {
            if (!initialized)
                return;

            for (uint32_t y = 0; y < get_framebuffer().height; y++)
                for (uint32_t x = 0; x < get_framebuffer().width; x++)
                    fb.addr[y * get_framebuffer().pitch + x] = color;
        }
    };
}