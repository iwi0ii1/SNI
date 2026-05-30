# Source code rules:
1. ## Immutability
  - **`const` discipline**: Use `const` wherever possible to enforce read‑only semantics and prevent unintended mutation of critical state.

2. ## Phase structure
  - **Phase separation**: Each phase must contain:
    - `api/` -> clean accessors for later phases to read encapsulated critical states.
    - `private/` -> messy parsing and implementation details, hidden from outsiders.
    - `*_init` function -> entry point called from sup/start/start64.asm with no parameters and no return values.

3. ## State management
  - **No globals**: Never define global variables. Only `static` variables inside `.c/.cpp` files are permitted.
  - **Init ownership**: Only `init.*` files may define and encapsulate critical information exposed through `api/`

4. ## Encapsulation
  - **Private communication**: Private parts may only communicate via headers or `extern`. No direct cross‑pollution of internals.
  - **API contract**: `api/` exposes externs and clean accessors, but never implements logic. Other phases query only through API.

5. ## Execution pipeline
  - **Init-style pipeline**: Each phase follows an init‑style execution pipeline. The order is documented implicitly in `init.asm`, making execution predictable and self‑documenting.

6. ## Debugging
  - **Halt in error condition**: Always prefer to halt in an infinite loop to avoid continuation of farther crashes.