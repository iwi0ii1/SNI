// Implementation of `mem.inc` declarations

#include "shared/mem.h"

uint8_t shared_mem_cmp(const void* const b_ptr1, const void* const b_ptr2, const uint32_t b_count) {
    const uint8_t* const ptr1 = b_ptr1;
    const uint8_t* const ptr2 = b_ptr2;

    for (uint32_t i = 0; i < b_count; ++i)
        if (ptr1[i] != ptr2[i])
            return 1;

    return 0;
}