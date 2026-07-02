// Implementations of things inside "text.inc"

#include "shared/text.h"

#define VGA_WIDTH  80
#define VGA_HEIGHT 25

#define VGA_LAST_SLOT 1999

static uint16_t cursor_pos = 0;

/// @brief Scroll VGA Text Buffer by given repetitions
static void ks_shared_text_internal_scroll(const uint8_t rep) {
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

    cursor_pos -= VGA_WIDTH * rep;
}





void ks_shared_text_putc(const unsigned char ch, const uint8_t attr) {
    if (cursor_pos > VGA_LAST_SLOT) // cursor_pos must be at least 2000 to reach this
        ks_shared_text_internal_scroll(1);

    volatile uint16_t* const vga_tb = (volatile uint16_t* const)(uintptr_t)0xB8000; // GCC locked-in on this one
    vga_tb[cursor_pos] = ((uint16_t)attr << 8) | ch;

    ++cursor_pos;
}



void ks_shared_text_aputs(const unsigned char* const ch_ptr, const uint8_t attr) {
    for (uint16_t i = 0; ch_ptr[i] != '\0'; ++i)
        ks_shared_text_putc(ch_ptr[i], attr);
}



void ks_shared_text_fill_char(const unsigned char ch, const uint8_t attr) {
    cursor_pos = 0;
    for (uint16_t i = 0; i <= VGA_LAST_SLOT; ++i)
        ks_shared_text_putc(ch, attr);

    cursor_pos = 0; // Remember to reset cursor position after the filling (most likely used for clearing the screen)
}



void ks_shared_text_reposition_cursor(const uint8_t x_coord, const uint8_t y_coord) {
    cursor_pos = (y_coord << 6) + (y_coord << 4) + x_coord;
}



uint16_t ks_shared_text_get_cursor_pos(void) {
    const uint8_t x = cursor_pos % VGA_WIDTH;
    const uint8_t y = cursor_pos / VGA_WIDTH;

    return ((uint16_t)x << 8) | y;
}



void ks_shared_text_newline_cursor(const uint8_t rep) {
    if (rep == 0)
        return;

    const uint16_t pos = ks_shared_text_get_cursor_pos();
    const uint8_t x = (const uint8_t)(pos >> 8);
    const uint8_t y = (const uint8_t)(pos & 0xFF); // AND there to preserve bits

    if (y + rep >= VGA_HEIGHT)
        ks_shared_text_internal_scroll(rep);

    ks_shared_text_reposition_cursor((uint8_t)0, y + rep);
}