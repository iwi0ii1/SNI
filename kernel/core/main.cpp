#include <cstdint>

extern "C" {
    struct boot_info;

    void main() noexcept {
        volatile uint16_t* const VGA = reinterpret_cast<uint16_t*>(0xB8000);
        
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

        
        char msg[] = {'H','E','L','L','O',0};

        for (int i = 0; msg[i] != '\0'; ++i)
            VGA[i] = (0xF0 << 8) | msg[i];
    }
}