#pragma once
#include <stdint.h>

/**
 * @brief Display: Put a character to VGA text buffer (0xB8000)
 * @param attr_char Attribute and character. Example: 0xF041 ('A' in white bg, black fg)
 */
extern void DS_vgatb_putchar(uint16_t attr_char, uint16_t pos);

/**
 * @brief Display: Put a character to VGA text buffer (0xB8000) according to a tracked cursor
 * @param attr_char Attribute and character. Example: 0xF041 ('A' in white bg, black fg)
 */
extern void DS_vgatb_putcharbc(uint16_t attr_char);