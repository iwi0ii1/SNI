#include <cstdint>

__attribute__((used, section(".multiboot")))
static const unsigned int multiboot_header[] = {
    0xE85250D6, // magic
    0,          // architecture
    24,         // header length (NOT 8)
    -(0xE85250D6 + 0 + 24),

    0, 0, 8, 0  // END TAG (required!)
};