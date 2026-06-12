#include "shared/gcc_attr.h"
#include "phases/ecp/private/interrupts/default_isr/default_isr.h"
#include <stdint.h>

#define IDT_ENTRIES 256
#define IDT_GATE_INTERRUPT 0x8E

struct ATTR_PACKED idt_gate {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t  ist;
    uint8_t  type_attributes;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t reserved;
};

struct ATTR_PACKED idtr {
    uint16_t limit;
    uint64_t base;
};

ATTR_ALIGNED(16) static struct idt_gate ecp_idt[IDT_ENTRIES];

/// @brief Basically an ISR installer. But in the computer term, it is known as `gate`.
void ecp_interrupts_set_gate(const uint8_t vector, const uint64_t isr_ptr) {
    ecp_idt[vector].offset_low      = (uint16_t)(isr_ptr & 0xFFFF);
    ecp_idt[vector].selector        = 0x18; // 64-bit Long Mode Code Selector
    ecp_idt[vector].ist             = 0;
    ecp_idt[vector].type_attributes = IDT_GATE_INTERRUPT;
    ecp_idt[vector].offset_mid      = (uint16_t)((isr_ptr >> 16) & 0xFFFF);
    ecp_idt[vector].offset_high     = (uint32_t)((isr_ptr >> 32) & 0xFFFFFFFF);
    ecp_idt[vector].reserved        = 0;
}

/**
 * void ecp_interrupts_init(void)
 * * Assembles the IDT entries using your explicit modular ISR symbols.
 */
void ecp_interrupts_init(void) {
    // 1. Explicitly link the critical CPU exception lines to your isr/ implementations
    ecp_interrupts_set_gate(0,  (uint64_t)ecp_interrupts_default_isr_df);
    ecp_interrupts_set_gate(1,  (uint64_t)ecp_interrupts_default_isr_db);
    ecp_interrupts_set_gate(2,  (uint64_t)ecp_interrupts_default_isr_nmi);
    ecp_interrupts_set_gate(3,  (uint64_t)ecp_interrupts_default_isr_bp);
    ecp_interrupts_set_gate(4,  (uint64_t)ecp_interrupts_default_isr_of);
    ecp_interrupts_set_gate(5,  (uint64_t)ecp_interrupts_default_isr_br);
    ecp_interrupts_set_gate(6,  (uint64_t)ecp_interrupts_default_isr_ud);
    ecp_interrupts_set_gate(7,  (uint64_t)ecp_interrupts_default_isr_nm);
    ecp_interrupts_set_gate(8,  (uint64_t)ecp_interrupts_default_isr_df);
    ecp_interrupts_set_gate(10, (uint64_t)ecp_interrupts_default_isr_ts);
    ecp_interrupts_set_gate(11, (uint64_t)ecp_interrupts_default_isr_np);
    ecp_interrupts_set_gate(12, (uint64_t)ecp_interrupts_default_isr_ss);
    ecp_interrupts_set_gate(13, (uint64_t)ecp_interrupts_default_isr_gp);
    ecp_interrupts_set_gate(14, (uint64_t)ecp_interrupts_default_isr_pf);
    ecp_interrupts_set_gate(16, (uint64_t)ecp_interrupts_default_isr_mf);
    ecp_interrupts_set_gate(17, (uint64_t)ecp_interrupts_default_isr_ac);
    ecp_interrupts_set_gate(18, (uint64_t)ecp_interrupts_default_isr_mc);
    ecp_interrupts_set_gate(19, (uint64_t)ecp_interrupts_default_isr_xm);
    ecp_interrupts_set_gate(20, (uint64_t)ecp_interrupts_default_isr_ve);
    ecp_interrupts_set_gate(30, (uint64_t)ecp_interrupts_default_isr_sx);

    // 2. Construct IDTR pointer block
    struct idtr pointer;
    pointer.limit = (sizeof(struct idt_gate) * IDT_ENTRIES) - 1;
    pointer.base  = (uint64_t)&ecp_idt;

    // 3. Force state to CPU
    __asm__ volatile("lidt %0" : : "m"(pointer));
}