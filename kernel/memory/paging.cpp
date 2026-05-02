#include <cstdint>

static uint64_t pml4[512] __attribute__((aligned(4096)));
static uint64_t pdpt[512] __attribute__((aligned(4096)));
static uint64_t pd[512] __attribute__((aligned(4096)));
static uint64_t pt[512] __attribute__((aligned(4096)));

void map(uint64_t virt, uint64_t phys) noexcept {
    uint64_t index = (virt >> 12) & 0x1FF;
    pt[index] = phys | 3;
}

extern "C"
void init_paging() noexcept {
    for (int i = 0; i < 512; i++) {
        pml4[i] = 0;
        pdpt[i] = 0;
        pd[i]   = 0;
        pt[i]   = 0;
    }

    pml4[0] = reinterpret_cast<uint64_t>(pdpt) | 3;
    pdpt[0] = reinterpret_cast<uint64_t>(pd) | 3;
    pd[0]   = reinterpret_cast<uint64_t>(pt) | 3;

    for (uint64_t i = 0; i < 512; i++)
        map(i * 0x1000, i * 0x1000);

    /*for (uint64_t i = 0; i < 0x20000; i += 0x1000)
        map(0x800000 + i, 0x800000 + i);*/

    asm volatile("mov %0, %%cr3" :: "r"(pml4));
}