#pragma once
#include <cstdint>

namespace bos {
    struct coord final { uint16_t x, y; };

    /**
     * @brief VGA Text thingy, like the `0xB8000` thing
     */
    class vga final {
    private:        
        inline static volatile uint16_t* const vga_addr = reinterpret_cast<volatile uint16_t*>(0xB8000);
        inline static uint16_t cursor = 0;

    public:
        /**
         * @brief Write a character to VGA according to cursor.
         * @note When cursor reached to the bottom right, it resets to top left.
         */
        inline static void put_char(const char ch) noexcept {
            if (cursor >= 2000) cursor = 0; // simple wrap
            vga_addr[cursor++] = static_cast<uint16_t>(ch) | (0x0F << 8);
        }

        /**
         * @brief Write a string to VGA according to cursor.
         * @note When cursor reached to the bottom right, it resets to top left.
         */
        inline static void write_str(const char* const str, const uint16_t count) noexcept {
            for (uint16_t i = 0; i < count; ++i)
                put_char(str[i]);
        }

        /**
         * @brief Get cursor position.
         * @note Starts from 0
         */
        [[nodiscard]]
        inline static coord get_cursor_pos() noexcept {
            return { static_cast<uint16_t>(cursor % 80), static_cast<uint16_t>(cursor / 80) };
        }

        /**
         * @brief Set cursor position.
         * @return True -> successful ; False -> X or Y coord not within `80x25`
         * @note Next write might result in overwrite.
         * @note Parameter coordination should starts in 0, not 1
         */
        [[nodiscard]]
        inline static bool set_cursor_pos(const coord coordination) noexcept {
            if (coordination.x >= 80 || coordination.y >= 25)
                return false;

            cursor = coordination.x * coordination.y;
            return true;
        }
    };
}