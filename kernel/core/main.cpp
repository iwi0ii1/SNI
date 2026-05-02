#include <cstdint>

extern "C"
int strncmp(const char* a, const char* b, unsigned long n) {
    for (unsigned long i = 0; i < n; i++) {
        if (a[i] != b[i]) {
            return (unsigned char)a[i] - (unsigned char)b[i];
        }
        if (a[i] == '\0') return 0;
    }
    return 0;
}

extern "C" {
    void main() noexcept {
        volatile uint16_t* const VGA = reinterpret_cast<volatile uint16_t* const>(0xB8000);
        
        /*VGA[0] = (0xF0 << 8) | 'H';
        VGA[1] = (0xF0 << 8) | 'e';
        VGA[2] = (0xF0 << 8) | 'l';
        VGA[3] = (0xF0 << 8) | 'l';
        VGA[4] = (0xF0 << 8) | 'o';
        VGA[5] = (0xF0 << 8) | ' ';
        VGA[6] = (0xF0 << 8) | 'w';
        VGA[7] = (0xF0 << 8) | 'o';
        VGA[8] = (0xF0 << 8) | 'r';
        VGA[9] = (0xF0 << 8) | 'l';
        VGA[10] = (0xF0 << 8) | 'd';
        VGA[11] = (0xF0 << 8) | '!';
        VGA[12] = (0xF0 << 8) | '!';*/
        


        for (uint16_t i = 0; i < 10; i++)
            VGA[i] = 0x0F00 | ('0' + i);
    }
}