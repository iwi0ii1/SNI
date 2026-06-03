// Read ACPI table.

struct hdp_acpi_table_t;

/**
 * @brief Get ACPI table (which is filled with ptrs to another firmware tables like MCFG, MADT, FADT, SSDT, etc)
 * @return Table fields are all `void*`, requires manual casts to the correct `struct`
 */
extern const struct hdp_acpi_table_t* const hdp_api_get_acpi_table(void);