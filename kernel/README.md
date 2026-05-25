# Kernel initialization and Execution flow:
```
SUP (Set-Up Phase) -> HDP (Hardware Discovery Phase) -> HAP (Hardware Abstraction Phase) -> RTP (Runtime Phase)
```

And this kernel only supports `x64` architecture.

`_start` is in **sup/** for enabling long mode and setting things up before the rest of the phases.
It will then far jump to `_start64` after the long mode transition and some paging, IDT, GDT things.