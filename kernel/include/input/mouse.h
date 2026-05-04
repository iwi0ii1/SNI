#pragma once
#include <stdint.h>

/**
 * @brief Input: Is this combination of mouse click achieved
 */
extern _Bool IN_ms_combo_hit(uint8_t combo);

/**
 * @brief Input: Is the mouse click inside the bits
 * @param buttons 3 bits for 3 buttons: `LMB`, `MMB`, `RMB`
 */
extern _Bool IN_ms_any_hit(uint8_t buttons);

/**
 * @brief Input: Is the mouse scrolled in a direction
 * @param direction Up (true) or Down (false)
 */
extern _Bool IN_ms_scroll(_Bool direction);