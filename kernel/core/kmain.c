#include <stdint.h>

void kmain(uint32_t magic, void* mb_addr) {
    uint16_t* const VGA = 0xB8000;
    VGA[0] = 0xF041;
}