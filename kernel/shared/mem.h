#pragma once

#include "shared/type.h"

/**
 * @brief Compare null-terminated string of bytes
 * @param b_ptr1 First string (ptr)
 * @param b_ptr2 Second string (ptr)
 * @param b_count Bytes count to compare
 * @return 0 for same, 1 for different
 */
extern byte_t ks_shared_memcmp(const void* const b_ptr1, const void* const b_ptr2, const dword_t b_count);



#define KS_SHARED_MEM_BIN_TAG 2
#define KS_SHARED_MEM_OCT_TAG 8
#define KS_SHARED_MEM_DEC_TAG 10
#define KS_SHARED_MEM_HEX_TAG 16

/**
 * @brief Convert unsigned 64-bit integer to string
 * @param dest Where the string goes (ptr)
 * @param src Unsigned 64-bit integer
 * @param base Base to represent in string (binary, octal, decimal, hexal)
 * @note Converted string doesn't include prefixes like `0b`, `0`, `0x`
 */
extern void ks_shared_memU64Tostr(void* const dest, const qword_t src, const byte_t base);



/**
 * @brief Concatenate 2 null-terminated strings of bytes
 * @param dest Where the concatenate string goes (ptr)
 * @param b_ptr1 First string (ptr)
 * @param b_ptr2 Second string (ptr)
 */
extern void ks_shared_memcat(void* const dest, const void* const b_ptr1, const void* const b_ptr2);



/**
 * @brief Calculate the length of 2 null-terminated strings of bytes
 * @param b_ptr First string (ptr)
 * @param unit How many raw bytes count as one (byte: 1, word: 2, dword: 4, qword: 8, xmmword: 16)
 * @return Rounded length. However 65,535 for invalid `unit`
 */
extern word_t ks_shared_memlen(const void* const b_ptr, const byte_t unit);