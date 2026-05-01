#include <cstdint>
#include "serial.hpp"

extern "C" {
    static void outb(uint16_t port, uint8_t val) {
        asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
    }

    static uint8_t inb(uint16_t port) {
        uint8_t ret;
        asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
        return ret;
    }

    void serial_init() {
        outb(0x3F8 + 1, 0x00);
        outb(0x3F8 + 3, 0x80);
        outb(0x3F8 + 0, 0x03);
        outb(0x3F8 + 1, 0x00);
        outb(0x3F8 + 3, 0x03);
        outb(0x3F8 + 2, 0xC7);
        outb(0x3F8 + 4, 0x0B);
    }

    void serial_write(char c) {
        while (!(inb(0x3F8 + 5) & 0x20));
        outb(0x3F8, c);
    }

    void serial_write_string(const char* s) {
        while (*s)
            serial_write(*s++);
    }
}