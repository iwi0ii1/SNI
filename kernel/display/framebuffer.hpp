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

        inline static const decltype(fb)& fb_cref = fb; // Constant reference to framebuffer info

        /**
         * @brief Set a specific pixel to a color (hexal)
         */
        inline static void put_pixel(const uint32_t x, const uint32_t y, const uint32_t color) noexcept {
            if (
                !initialized
                 || x >= fb_cref.width
                 || y >= fb_cref.height
            ) return;

            fb.addr[y * fb_cref.pitch + x] = color;
        }

        /**
         * @brief Fill the entire screen with a color (hexal)
         * @note Might be slow in some cases
         */
        static void fill(const uint32_t color) noexcept;
    };
}