#include <stdint.h>
#include "../../debug/serial.hpp"

__attribute__((section(".multiboot"), used))
static const uint32_t multiboot_header[] = {
    0xE85250D6,
    0,
    16, // header size (NOT 8)
    -(0xE85250D6 + 0 + 16),

    0, 0, 8, 0 // END TAG (required)
};

extern "C" {
    struct boot_memory_info final {

    };

    struct boot_framebuffer final {

    };

    struct boot_modules final {

    };

    struct boot_info final {
        boot_memory_info memory;
        boot_framebuffer framebuffer;
        boot_modules modules;
        bool smp_available;
    };

    void main(const boot_info&) noexcept;

    extern "C" [[noreturn]]
    void _start() {
        asm volatile (
            "mov $stack_top, %rsp"
        );

        serial_init();
        serial_write_string("WhiteOS alive\n");

        for (;;)
            asm volatile("hlt");
    }

}