#pragma once

#include <stdint.h>
#include <stddef.h>

extern uint8_t hdp_pci_read8(const uint8_t bus, const uint8_t device, const uint8_t function, const uint16_t offset);   // Get a byte stored in an offset
extern uint16_t hdp_pci_read16(const uint8_t bus, const uint8_t device, const uint8_t function, const uint16_t offset); // Get 2 bytes stored in an offset
extern uint32_t hdp_pci_read32(const uint8_t bus, const uint8_t device, const uint8_t function, const uint16_t offset); // Get 4 bytes stored in an offset

/**
 * @brief Get vendor according to the given bus, device, function and offset.
 */
static inline uint16_t hdp_pci_get_vendor16(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read16(bus, device, function, 0x00); }

/**
 * @brief Get device according to the given bus, device, function and offset
 */
static inline uint16_t hdp_pci_get_device16(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read16(bus, device, function, 0x02); }

/**
 * @brief Get command according to the given bus, device, function and offset
 */
static inline uint16_t hdp_pci_get_command16(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read16(bus, device, function, 0x04); }

/**
 * @brief Get status according to the given bus, device, function and offset
 */
static inline uint32_t hdp_pci_get_status32(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read32(bus, device, function, 0x06); }

/**
 * @brief Get class according to the given bus, device, function and offset
 * @param type Class types: base class (0), subclass (1), progIF (2), revision ID (3)
 * @return -1 for failure
 */
static inline uint8_t hdp_pci_get_class8(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function,
    const uint8_t type
) {
    if (type > 3)
        return -1;

    return hdp_pci_read8(bus, device, function, 0x0B - type); // 0x0B - 1 = 0x0A (subclass offset)
}


/**
 * @brief Get header according to the given bus, device, function and offset
 */
static inline uint8_t hdp_pci_get_header8(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read8(bus, device, function, 0x0E); }


/**
 * @brief Get BAR (Base Address Register) according to the given bus, device, function and offset
 * @param slot Slot index (0 based, ranged 0..5)
 * @return -1 for failure
 */
static inline uint32_t hdp_pci_get_bar32(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function,
    const uint8_t slot
) {
    if (slot > 5)
        return -1;

    return hdp_pci_read32(bus, device, function, 0x10 + (slot << 2)); // n << 1   ->   n * 2  ,   n << 2   ->   n * 4, and so on.
}


/**
 * @brief Get subsystem according to the given bus, device, function and offset
 */
static inline uint32_t hdp_pci_get_subsystem32(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read32(bus, device, function, 0x2C); }


/**
 * @brief Get capabilities pointer according to the given bus, device, function and offset
 */
static inline uint8_t hdp_pci_get_capabilities_ptr8(
    const uint8_t bus,
    const uint8_t device,
    const uint8_t function
) { return hdp_pci_read8(bus, device, function, 0x34); }