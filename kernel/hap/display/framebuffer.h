#pragma once
#include <stdint.h>

/**
 * @brief Display: Init framebuffer
 */
extern void DS_fb_init();

/**
 * @brief Display: Put pixel in framebuffer
 */
extern void DS_fb_putpx(uint16_t x, uint16_t y, uint32_t color);

/**
 * @brief Display: Fill framebuffer with a color
 */
extern void DS_fb_fill(uint32_t color);