# Source code rules:
 - Each phase should have `api/` (for other phases, cannot have helper functions), `private/` (smaller domains of a phase)
 - Only `private/*domain*/*domain.h*` can be included by other domains, kinda like an API between domains but not an explicit `api/`
 - No relative includes, always starts from `kernel/`
 - Always `const` unless mutability is forced.
 - Never define global variables across translation units (exclude `static` variables)
 - Naming convention: **phase-domain-action**, example: `sup_gdt_init` (except scoped identifiers)
 - Do init-style execution pipeline