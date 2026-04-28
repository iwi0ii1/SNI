#include <cstdint>

extern "C" {
    struct boot_info;

    void main(const boot_info& b_info) noexcept {
        volatile uint16_t* const VGA = reinterpret_cast<uint16_t*>(0xB8000);
        
        const char* const msg = "Hello World";

        const uint8_t color = 0xF0; // white bg, black fg

        for (int i = 0; msg[i] != 0; ++i)
            VGA[i] = (color << 8) | msg[i];
    }
}