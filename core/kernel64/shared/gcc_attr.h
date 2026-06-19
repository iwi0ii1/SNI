// GCC attributes macros.
#pragma once

#define ATTR_OF(x) __attribute__((x)) // Attribute of...

#define ATTR_PACKED ATTR_OF(packed) // Pack memory (no padding for alignment)
#define ATTR_ALIGNED(x) ATTR_OF(aligned(x)) // Aligned by...
#define ATTR_NO_SSE ATTR_OF(target("no-sse,no-sse2,no-mmx")) // No SSE, MMX
#define ATTR_ALWAYS_INLINE ATTR_OF(always_inline) // Always inline