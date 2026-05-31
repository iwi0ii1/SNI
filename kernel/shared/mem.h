#pragma once

#include <stdint.h>

/**
 * @brief Compare string of bytes
 * @param b_ptr1 First string (ptr)
 * @param b_ptr2 Second string (ptr)
 * @param b_count Bytes count to compare
 * @return 0 for same, else different
 */
extern _Bool hdp_shared_memcmp(const void* const b_ptr1, const void* const b_ptr2, const uint32_t b_count);