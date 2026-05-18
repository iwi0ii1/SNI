# Kernel initialization and Execution flow:
```
SUP -> HDP -> HAP-> Runtime
```

And this kernel only supports `x64` architecture.

`_start` is in **sup/** for enabling long mode and setting things up before the rest of the phases.