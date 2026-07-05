// Kernel SNI main

#include "shared/gcc_attr.h"
#include "shared/type.h"

/**
 * @brief Entrypoint of SNI's 64-bit kernel
 * @param firmware_type 0 for unknown, 1 for BIOS, 2 for UEFI
 * @param firmware_provided_info Raw binary blobs containing firmware provided info that will be parsed later
 */
[[noreturn]] ATTR_SECTION(.ks_main)
void ks_main(const uint8_t firmware_type, const void* const firmware_provided_info) {
    while (1)
        __asm__("hlt");
}