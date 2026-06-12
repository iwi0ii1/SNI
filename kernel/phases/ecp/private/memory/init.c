#include "shared/gcc_attr.h"
#include <stdint.h>

// Paging structural flags for x86_64 Long Mode
#define PAGE_PRESENT     (1ULL << 0)
#define PAGE_READ_WRITE  (1ULL << 1)
#define PAGE_HUGE        (1ULL << 7)
#define PAGE_ENTRIES     512

// Statically allocated, 4KiB page-aligned tables local to this domain.
// `permanent_pml4` is global so that your modes domain can read its base address.
ATTR_ALIGNED(4096) uint64_t permanent_pml4[PAGE_ENTRIES];
ATTR_ALIGNED(4096) static uint64_t permanent_pdpt[PAGE_ENTRIES];
ATTR_ALIGNED(4096) static uint64_t permanent_pds[6][PAGE_ENTRIES];

/**
 * @brief Computes and links the 4-level paging infrastructure required to map out the mandatory 6 GiB identity execution context.
 */
void ecp_memory_init(void) {
    // 1. Clear out any junk data to prevent table corruption
    for (int i = 0; i < PAGE_ENTRIES; i++) {
        permanent_pml4[i] = 0;
        permanent_pdpt[i] = 0;
        for (int j = 0; j < 6; j++)
            permanent_pds[j][i] = 0;
    }

    // 2. Link Tier 4 (PML4) -> Tier 3 (PDPT)
    // Map the very first slot of virtual space to our Page Directory Pointer Table
    permanent_pml4[0] = (uintptr_t)permanent_pdpt | PAGE_PRESENT | PAGE_READ_WRITE;

    // 3. Link Tier 3 (PDPT) -> 6 Page Directories
    // Each Page Directory entry handles 1 GiB of virtual address space
    for (int i = 0; i < 6; i++)
        permanent_pdpt[i] = (uintptr_t)&permanent_pds[i] | PAGE_PRESENT | PAGE_READ_WRITE;

    // 4. Identity map the full 6 GiB using 2 MiB Huge Pages
    // Loops through all 6 directories, filling all 512 entries per directory (6 * 512 = 3072 entries)
    uint64_t physical_address = 0;
    for (int page_dir = 0; page_dir < 6; page_dir++) {
        for (int entry = 0; entry < PAGE_ENTRIES; entry++) {
            permanent_pds[page_dir][entry] = physical_address | PAGE_PRESENT | PAGE_READ_WRITE | PAGE_HUGE;
            physical_address += 0x200000; // Increment step by exactly 2 MiB
        }
    }
}