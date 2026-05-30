# Rules for this source code:
 - `const` as much as possible
 - Each phase must have
   - `api/` (for later phases to read encapsulated critical states)
   - `private/` (where every messy parts live and defines what's inside `api/`)
   - `*_init` label/function (will be called accordingly in sup/start/start64.asm with no parameters and return values)
 - Never define a global variable anywhere (exclude **static variable** inside `.c/.cpp`)
 - Only `init.*` are allowed to define things inside `api/`
 - Private parts can only communicate via headers or `extern`
 - Encourages init-style execution pipeline for each phases and private parts.