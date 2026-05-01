#pragma once

extern "C" {
    extern void serial_init();
    extern void serial_write(char c);
    extern void serial_write_string(const char* s);
}