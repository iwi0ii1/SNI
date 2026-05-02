/*#include <cstdint>

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

    asm volatile("mov %0, %%cr3" :: "r"(pml4));
}*/

#include <cstdint>

// Four levels of tables plus an extra Page Table to cover 2MB-4MB
static uint64_t pml4[512] __attribute__((aligned(4096)));
static uint64_t pdpt[512] __attribute__((aligned(4096)));
static uint64_t pd[512]   __attribute__((aligned(4096)));
static uint64_t pt1[512]  __attribute__((aligned(4096))); // Covers 0MB - 2MB
static uint64_t pt2[512]  __attribute__((aligned(4096))); // Covers 2MB - 4MB

extern "C"
void init_paging() noexcept {
    // 1. Clear all tables to be safe
    for (int i = 0; i < 512; i++) {
        pml4[i] = pdpt[i] = pd[i] = pt1[i] = pt2[i] = 0;
    }

    // 2. Link the levels (Present | Writable = 3)
    pml4[0] = reinterpret_cast<uint64_t>(pdpt) | 3;
    pdpt[0] = reinterpret_cast<uint64_t>(pd)   | 3;

    // Link the Page Tables into the Page Directory
    pd[0] = reinterpret_cast<uint64_t>(pt1) | 3; // First 2MB
    pd[1] = reinterpret_cast<uint64_t>(pt2) | 3; // Second 2MB (where your stack lives)

    // 3. Identity map 0MB to 2MB (VGA at 0xB8000, Kernel at 1MB)
    for (uint64_t i = 0; i < 512; i++) {
        uint64_t addr = i * 0x1000;
        pt1[i] = addr | 3;
    }

    // 4. Identity map 2MB to 4MB (Stack at 3MB)
    for (uint64_t i = 0; i < 512; i++) {
        uint64_t addr = 0x200000 + (i * 0x1000);
        pt2[i] = addr | 3;
    }

    // 5. Tell the CPU where the top-level table is
    // The "memory" clobber tells the compiler not to reorder this
    asm volatile("mov %0, %%cr3" :: "r"(pml4) : "memory");
}