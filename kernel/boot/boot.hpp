#include "../display/vga_text.hpp"
#include <cstdint>
#include <cstddef>

namespace bos {
    constexpr uint32_t MULTIBOOT2_MAGIC = 0x36d76289;
    constexpr uint8_t FB_TYPE_RGB = 1;
    constexpr uint32_t FB_TYPE_OFFSET = 33;

    struct tag_header_t final {
        uint32_t type;
        uint32_t size;
    };



    enum class info_type : uint32_t { framebuffer = 8, memory_map = 6, modules = 3 };

    /**
     * @brief Boot kind of shits.
     */
    class boot final {
    private:
        inline static bool initialized = false;
        static inline const uint8_t* base = nullptr;
        static inline uint32_t total = 0;

    public:
        struct framebuffer_t final {
            volatile uint64_t* addr;
            uint32_t width;
            uint32_t height;
            uint32_t pitch;
            uint32_t bpp;
        };

        struct memory_map_t final {

        };

        struct modules_t final {

        };


        /**
         * @brief Initialize framebuffer manager.
         */
        inline static void init(const uint32_t magic, const void* info) noexcept {
            if (initialized)
                return;

            base = nullptr;
            total = 0;

            if (magic != MULTIBOOT2_MAGIC)
                for(;;); // Stucked here??

            base = reinterpret_cast<const uint8_t*>(info);
            total = *reinterpret_cast<const uint32_t*>(base);

            if (total < 16) {
                base = nullptr;
                total = 0;
                return;
            }

            initialized = true;
        }

        /**
         * @brief Retrieve a specific bootloader-given info.
         */
        static const tag_header_t* find(const info_type type) noexcept;

        static framebuffer_t get_framebuffer() noexcept;
        static memory_map_t get_memory_map() noexcept;
        static modules_t get_modules() noexcept;
    };
}