#pragma once
#include <stdint.h>

/**
 * @brief Enum full of normal keyboard keys (excluding modifiers)
 */
enum IN_kb_nm_keys {
    key_unknown = 0,

    // --- Alphanumeric row ---
    key_backtick,
    key_1, key_2, key_3, key_4, key_5,
    key_6, key_7, key_8, key_9, key_0, 
    key_hyphen, key_equal, key_backspace,

    key_tab,

    key_q, key_w, key_e, key_r, key_t,
    key_y, key_u, key_i, key_o, key_p,

    key_left_bracket, key_right_bracket, key_backslash,

    key_a, key_s, key_d, key_f, key_g,
    key_h, key_j, key_k, key_l,

    key_semicolon, key_apostrophe, key_enter,

    key_z, key_x, key_c, key_v,
    key_b, key_n, key_m,

    key_comma, key_period, key_slash,

    key_space,

    // --- Function keys ---
    key_f1, key_f2, key_f3, key_f4, key_f5, key_f6, 
    key_f7, key_f8, key_f9, key_f10, key_f11, key_f12,

    // --- Navigation cluster ---
    key_insert, key_delete, key_home,
    key_end, key_page_up, key_page_down,

    key_arrow_up, key_arrow_down,
    key_arrow_left, key_arrow_right,

    // --- Numpad ---
    key_numpad_0, key_numpad_1, key_numpad_2,
    key_numpad_3, key_numpad_4, key_numpad_5,
    key_numpad_6, key_numpad_7, key_numpad_8,
    key_numpad_9,

    key_numpad_slash, key_numpad_star, key_numpad_minus,
    key_numpad_plus, key_numpad_enter, key_numpad_dot,

    // --- System / legacy keys ---
    key_escape, key_print_screen,
    key_scroll_lock, key_pause_break,

    // --- OS keys ---
    key_menu,
    key_left_windows, key_right_windows,

    // --- Extra / extended ---
    key_insert_extended, key_delete_extended,     key_home_extended,
    key_end_extended, key_page_up_extended, key_page_down_extended
};

/**
 * @brief Enum full of keyboard keys (only modifiers)
 */
enum IN_kb_mdf_keys {
    key_no_mdf = 0,
    key_caps_lock = 1 << 0,

    key_left_control = 1 << 1, key_right_control = 1 << 2,
    key_left_shift   = 1 << 3, key_right_shift   = 1 << 4,
    key_left_alt     = 1 << 5, key_right_alt     = 1 << 6,
    key_left_fn      = 1 << 7, key_right_fn      = 1 << 8
};

/**
 * @brief Input: Is this combo achieved by those keypresses
 * @param mdf_combo Modifier keys combo (only modifiers)
 * @param nm_combo Single normal key (not modifier)
 */
extern _Bool IN_kb_combo_hit(enum IN_kb_mdf_keys mdf_combo, enum IN_kb_nm_keys nm_combo);