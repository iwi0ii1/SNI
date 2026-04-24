#include <limine.h>

static volatile limine_framebuffer_request fb_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};

/**
 * @brief Where the kernel starts.
 */
extern "C"
void _start() noexcept {
    while (1)
        asm("hlt");

    
}