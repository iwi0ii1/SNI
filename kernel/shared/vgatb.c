// Implementations of things inside "vgatb.inc"

#include "shared/vgatb.h"

#define VGA_WIDTH  80
#define VGA_HEIGHT 25

#define CURSOR_END 1999

static uint16_t cursor_pos = 0;

/// @brief Scroll VGA Text Buffer by given repetitions
static void shared_vgatb_internal_scroll(const uint8_t rep) {
    if (rep == 0)
        return;

    volatile uint16_t* const vga =
        (volatile uint16_t*)0xB8000;

    const uint16_t blank = ((uint16_t)0x07 << 8) | ' ';

    // Move lines upward
    for (uint32_t row = 0; row < VGA_HEIGHT - rep; ++row)
        for (uint32_t col = 0; col < VGA_WIDTH; ++col)
            vga[row * VGA_WIDTH + col] = vga[(row + rep) * VGA_WIDTH + col];

    // Clear newly exposed lines at the bottom
    for (uint32_t row = VGA_HEIGHT - rep; row < VGA_HEIGHT; ++row)
        for (uint32_t col = 0; col < VGA_WIDTH; ++col)
            vga[row * VGA_WIDTH + col] = blank;
}

void shared_vgatb_putc(const unsigned char ch, const uint8_t attr) {
    if (cursor_pos >= CURSOR_END) {
        cursor_pos -= 80;
        shared_vgatb_internal_scroll(1);
    }

    volatile uint16_t* const vga_tb = (volatile uint16_t*)(uintptr_t)0xB8000; // GCC locked-in on this one
    vga_tb[cursor_pos] = ((uint16_t)attr << 8) | ch;

    ++cursor_pos;
}

void shared_vgatb_aputs(const unsigned char* const ch_ptr, const uint8_t attr) {
    for (uint16_t i = 0; ch_ptr[i] != '\0'; ++i)
        shared_vgatb_putc(ch_ptr[i], attr);
}

void shared_vgatb_fill_char(const unsigned char ch, const uint8_t attr) {
    cursor_pos = 0;
    for (uint16_t i = 0; i <= CURSOR_END; ++i)
        shared_vgatb_putc(ch, attr);

    cursor_pos = 0; // Remember to reset cursor position after the filling (most likely used for clearing the screen)
}

void shared_vgatb_reposition_cursor(const uint8_t x_coord, const uint8_t y_coord) {
    cursor_pos = (y_coord << 6) + (y_coord << 4) + x_coord;
}

uint16_t shared_vgatb_get_cursor_pos(void) {
    return ((cursor_pos % 80) << 8) | (cursor_pos / 80);
}

void shared_vgatb_newline_cursor(const uint8_t rep) {
    if (cursor_pos >= CURSOR_END) {
        cursor_pos -= 80;
        shared_vgatb_internal_scroll(1);
    }

    const uint16_t pos = shared_vgatb_get_cursor_pos();
    shared_vgatb_reposition_cursor((uint8_t)(pos >> 8), (uint8_t)(pos & 0xFF)); // AND there is to preserve bits
}