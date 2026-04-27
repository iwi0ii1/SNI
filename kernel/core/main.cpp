extern "C" {
    struct boot_info;

    void main(const boot_info& b_info) noexcept {/*
        volatile char* video = (volatile char*)0xB8000;

        const char* const msg = "WhiteOS is alive";

        for (int i = 0; msg[i]; i++) {
            video[i * 2] = msg[i];
            video[i * 2 + 1] = 0x07;
        }*/
    }
}