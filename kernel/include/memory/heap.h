#pragma once
#include <stdint.h>

/**
 * @brief Memory: Allocate memory on heap
 * @note Remember to free it using `MM_free_heap`
 * @param bytes The amount of bytes to allocate
 */
extern void* MM_alloc_heap(uint64_t bytes);

/**
 * @brief Memory: Free memory on heap
 * @param mem The memory to free
 */
extern void* MM_free_heap(void* mem);