// Implementation of `mem.inc` declarations

#include "shared/mem.h"

byte_t shared_mem_cmp(const void* const b_ptr1, const void* const b_ptr2, const dword_t b_count) {
    const uint8_t* const ptr1 = b_ptr1;
    const uint8_t* const ptr2 = b_ptr2;

    for (uint32_t i = 0; i < b_count; ++i)
        if (ptr1[i] != ptr2[i])
            return 1;

    return 0;
}



void shared_mem_u64_to_str(void* const dest, const qword_t src, const byte_t base) {
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
    unsigned char* d = (unsigned char*)dest;
    const unsigned char* s1 = (unsigned char*)b_ptr1;
    const unsigned char* s2 = (unsigned char*)b_ptr2;

    while (*s1)
        *d++ = *s1++;

    while (*s2)
        *d++ = *s2++;

    *d = '\0';
}



word_t shared_mem_len(const void* const b_ptr, const byte_t unit) {
    if (unit == 0 || unit & (unit - 1) != 0) // Can only be power of two.
        return (word_t)-1;

    word_t len = 0;
    const byte_t* const bytes = (const byte_t*)b_ptr;

    while (bytes[len] != '\0')
        ++len;

    return (len + unit - 1) / unit; // Round up final value. Like len=5 unit=4, should be 2 not 1
}