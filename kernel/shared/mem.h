#pragma once

#include <stdint.h>

/**
 * @brief Compare string of bytes
 * @param b_ptr1 First string (ptr)
 * @param b_ptr2 Second string (ptr)
 * @param b_count Bytes count to compare
 * @return 0 for same, 1 for different
 */
extern uint8_t shared_mem_cmp(const void* const b_ptr1, const void* const b_ptr2, const uint32_t b_count);



#define SHARED_MEM_BIN_TAG 2
#define SHARED_MEM_OCT_TAG 8
#define SHARED_MEM_DEC_TAG 10
#define SHARED_MEM_HEX_TAG 16

/**
 * @brief Convert unsigned 64-bit integer to string
 * @param dest Where the string goes (ptr)
 * @param src Unsigned 64-bit integer
 * @param base Base to represent in string (binary, octal, decimal, hexal)
 * @note Converted string doesn't include prefixes like `0b`, `0`, `0x`
 */
extern void shared_mem_u64_to_str(void* const dest, const uint64_t src, const uint8_t base);



/**
 * @brief Concatenate 2 strings of bytes
 * @param dest Where the concatenate string goes (ptr)
 * @param b_ptr1 First string (ptr)
 * @param b_ptr2 Second string (ptr)
 */
extern void shared_mem_cat(void* const dest, const void* const b_ptr1, const void* const b_ptr2);