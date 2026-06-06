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



void shared_mem_u64_to_str(void* const dest, const uint64_t src, const uint8_t base) {
    static const char digits[] = "0123456789ABCDEF";
    unsigned char* const dst = (unsigned char*)dest; // Interpret as BYTE

    switch (base) {
        case SHARED_MEM_BIN_TAG:
        case SHARED_MEM_OCT_TAG:
        case SHARED_MEM_DEC_TAG:
        case SHARED_MEM_HEX_TAG: {
            if (src == 0) { // Exception: zero
                dst[0] = '0';
                dst[1] = '\0';
                return;
            }

            char tmp[65] = {0};
            uint32_t i = 0;

            uint64_t value = src;

            while (value > 0) {
                const uint64_t remainder = value % base;
                tmp[i++] = digits[remainder];
                value /= base;
            }

            for (uint32_t j = 0; j < i; ++j)
                dst[j] = tmp[i - j - 1];

            dst[i] = '\0'; // Null-terminate

            break;
        }

        default: {
            *dst = '\0';
            break;
        }
    }
}



void shared_mem_cat(void* const dest, const void* const b_ptr1, const void* const b_ptr2) {
    
}