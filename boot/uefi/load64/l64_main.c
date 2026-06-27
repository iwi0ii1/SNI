// 64-bit loader from UEFI
#include <efi/efi.h>
#include <efi/efilib.h>

EFI_STATUS efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
    InitializeLib(ImageHandle, SystemTable);

    const CHAR16* str = (CHAR16*)"Hello world from UEFI!\n";
    Print(str);

    while (1);
    return EFI_SUCCESS;
}