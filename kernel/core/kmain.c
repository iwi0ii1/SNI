#include <stdint.h>

void main(void) {
    volatile uint16_t* const VGA = (volatile uint16_t* const)0xB8000;
    const char* const str = "Hello world!\0";

    for (uint8_t i = 0; str[i]; ++i)
        VGA[i] = 0xF000 | str[i];
}