#include <stdint.h>

void init_paging() {
    // We'll park 4 Page Directories starting at 0x202000
    uint64_t* pml4 = (uint64_t*)0x200000;
    uint64_t* pdpt = (uint64_t*)0x201000;
    uint64_t* pd0  = (uint64_t*)0x202000; // Maps 0-1GB
    uint64_t* pd1  = (uint64_t*)0x203000; // Maps 1-2GB
    uint64_t* pd2  = (uint64_t*)0x204000; // Maps 2-3GB
    uint64_t* pd3  = (uint64_t*)0x205000; // Maps 3-4GB

    // 1. Zero out everything (crucial for "No Stars")
    for(int i = 0; i < 512; i++) {
        pml4[i] = 0; pdpt[i] = 0;
        pd0[i] = 0;  pd1[i] = 0;
        pd2[i] = 0;  pd3[i] = 0;
    }

    // 2. Link PML4 to PDPT
    pml4[0] = (uint64_t)pdpt | 3;

    // 3. Link PDPT to the 4 Page Directories
    pdpt[0] = (uint64_t)pd0 | 3;
    pdpt[1] = (uint64_t)pd1 | 3;
    pdpt[2] = (uint64_t)pd2 | 3;
    pdpt[3] = (uint64_t)pd3 | 3;

    // 4. Identity Map all 4GB using 2MB Huge Pages
    for (uint64_t i = 0; i < 512; i++) {
        pd0[i] = (i * 0x200000) + 0x00000000 | 0x83;
        pd1[i] = (i * 0x200000) + 0x40000000 | 0x83;
        pd2[i] = (i * 0x200000) + 0x80000000 | 0x83;
        pd3[i] = (i * 0x200000) + 0xC0000000 | 0x83;
    }

    // 5. Load CR3
    // Use a pointer type so the compiler knows this is a 64-bit address
    uintptr_t pml4_phys = 0x200000;

    asm volatile(
        "mov %0, %%cr3"
        :
        : "r" (pml4_phys)
        : "memory"
    );
}