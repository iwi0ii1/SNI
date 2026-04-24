# Using C++, but shouldn't contain exceptions, STL, glibc, RTTI, heap allocation or threads or anything else.
## When compiling, include flags such as
 - `-ffreestanding`
 - `-fno-exceptions`
 - `-fno-rtti`
 - `-nostdlib`