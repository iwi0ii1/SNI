#pragma once
#include <stdint.h>

void serial_init();
void serial_write(char c);
void serial_write_string(const char* s);