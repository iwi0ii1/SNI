#include <stdint.h>

struct mb2_tag {
    uint32_t type;
    uint32_t size;
};

struct mb2_tag_framebuffer {
    uint32_t type;
    uint32_t size;
    uint64_t addr;
    uint32_t pitch;
    uint32_t width;
    uint32_t height;
    uint8_t  bpp;
    uint8_t  type_fb;
    uint16_t reserved;
};

void main(void* mb_addr, uint32_t magic) {
    struct mb2_tag* tag = (struct mb2_tag*)((uint8_t*)mb_addr + 8);
    uint32_t* lfb = 0;
    uint32_t width = 0;
    uint32_t height = 0;
    uint32_t pitch = 0;

    while (tag->type != 0) {
        if (tag->type == 8) {
            struct mb2_tag_framebuffer* fb = (struct mb2_tag_framebuffer*)tag;
            lfb = (uint32_t*)fb->addr;
            width = fb->width;
            height = fb->height;
            pitch = fb->pitch;
            break;
        }
        tag = (struct mb2_tag*)((uint8_t*)tag + ((tag->size + 7) & ~7));
    }

    if (lfb != 0) {
        /* 
           MANUAL OVERRIDE: 
           If the screen is black, we need to map this address. 
           Since our current paging code is "hardcoded" at 2MB, 
           we can sneak in a mapping for the LFB here.
        */
        uint64_t* pd = (uint64_t*)0x202000; // The PD we defined in paging.c
        uint64_t lfb_phys = (uint64_t)lfb;
        
        // Map the first 16MB of the LFB area just to be safe
        // This assumes lfb_phys is 2MB aligned (usually is)
        for(int i = 0; i < 8; i++) {
            // We find an unused slot in the PD or overwrite high entries
            // Let's use entries 256-264 (covers 512MB-528MB range usually, 
            // but we want to map it to its ACTUAL location)
            
            // BETTER: Use the actual index based on the LFB address
            uint64_t entry_index = (lfb_phys >> 21) & 0x1FF;
            pd[entry_index + i] = (lfb_phys + (i * 0x200000)) | 0x83;
        }
        
        // Refresh CR3 to apply changes
        asm volatile(
            "mov %%cr3, %%rax; mov %%rax, %%cr3"
            :
            :
            : "rax"
        );

        // Now try painting with the Pitch
        for (uint32_t y = 0; y < height; y++) {
            for (uint32_t x = 0; x < width; x++) {
                // Address = Base + (y * pitch) + (x * 4 bytes per pixel)
                uint32_t* pixel = (uint32_t*)((uint8_t*)lfb + (y * pitch) + (x * 4));
                *pixel = 0xFFFFFF; 
            }
        }
    }
}