# A brief intro:
## This kernel is made as a personal project, do not operate in the perspective of the industrial standard.
## This kernel is named SNI, which stands for smth else. You gotta find out, cuz even the devs don't know. However, the structure of the code is relatively clean though can be considered more strict than most codebases.
This kernel runs in phases while each phase will have their own responsibitilies, and the result will persist.
**ECP (Environment Compliance Phase)** is responsible for setting up and managing the environment for later phases to work. Nothing else.
**HDP (Hardware Discovery Phase)** is responsible for discovering hardwares through buses like PCI/PCIe, SATA/IDE, USB, PS/2, SPI, etc.
**HIP (Hardware Interface Phase)** is responsible for providing interfaces for later phases to use and manage hardware easier.
**RTP (RunTime Phase)** is basically where the real kernel work lives. Responsible for providing syscalls, managing almost anything u can think of.