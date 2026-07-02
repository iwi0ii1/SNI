#pragma once

#include <stdint.h>

/**
 * @brief Print character relative to the current cursor position
 * @param ch Character to print
 * @param attr Color Attribute
 */
extern void ks_shared_textPutc(const unsigned char ch, const uint8_t attr);

/**
 * @brief Print string but automatically scrolls and relative to the current cursor position
 * @param ch_ptr First char ptr
 * @param attr Color attribute
 * @note String MUST be null-terminated, else expect hitting #PF (assume such ISR implemented)
 */
extern void ks_shared_textAputs(const unsigned char* const ch_ptr, const uint8_t attr);

/**
 * @brief Fill VGATGB with a color
 * @param ch Character to fill
 * @param attr Color attribute
 */
extern void ks_shared_textFillChar(const unsigned char ch, const uint8_t attr);

/**
 * @brief Reposition internal cursor
 * @param x_coord X coordination
 * @param y_coord Y coordination
 * @note Starts with 0 index, not 1
 */
extern void ks_shared_textRepositionCursor(const uint8_t x_coord, const uint8_t y_coord);

/**
 * @brief Get cursor position
 * @return - Upper 8 bits -> X coordination
 * @return - Lower 8 bits -> Y coordination
 * @note Starts with 0 index, not 1
 */
extern uint16_t ks_shared_textGetCursorPos(void);

/**
 * @brief Newline cursor
 * @param rep Repetitions
 * @note Will scroll if reached the bottom
 */
extern void ks_shared_textNewlineCursor(const uint8_t rep);