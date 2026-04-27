#include <stdint.h>
//#include "../../debug/serial.hpp"

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

    [[noreturn]] void _start() {
        extern char stack_top;
        
        asm volatile (
            "mov %0, %%rsp"
            :
            : "r"(&stack_top)
        );

        auto outb = [](uint16_t port, uint8_t val) {
            asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
        };

        auto inb = [](uint16_t port) -> uint8_t {
            uint8_t ret;
            asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
            return ret;
        };

        // init COM1
        outb(0x3F8 + 3, 0x80);
        outb(0x3F8 + 0, 0x03);
        outb(0x3F8 + 1, 0x00);
        outb(0x3F8 + 3, 0x03);
        outb(0x3F8 + 2, 0xC7);
        outb(0x3F8 + 4, 0x0B);

        const char* msg = "WhiteOS alive\n";

        for (int i = 0; msg[i]; i++) {
            while (!(inb(0x3F8 + 5) & 0x20));
            outb(0x3F8, msg[i]);
        }

        for (;;)
            asm volatile("hlt");
    }
}