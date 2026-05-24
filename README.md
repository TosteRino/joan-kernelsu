# LG V30 (joan / H930) - KernelSU

Kernel z **KernelSU v0.9.5** (kprobe) dla **LineageOS 22.2** (`lineage-22.2-20260524-nightly-joan`) na LG V30 `joan` / H930.

Ten build jest dla klasycznego kernela **Linux 4.4.302 non-GKI**. Nie aktualizuj KernelSU Managera do nowszych wersji z banera w aplikacji; zostań przy **v0.9.5 (11872)**.

## Pliki

Repo zawiera skrypty i patche pozwalające odtworzyć źródła kernela z KernelSU:

- `prepare-source.sh` - klonuje kernel LineageOS, integruje KernelSU i aplikuje patche
- `build-kernel.sh` - buduje `Image.gz-dtb`
- `repack-boot.sh` - przepakowuje oficjalny `boot.img` z nowym kernelem
- `patches/` - małe poprawki potrzebne do kompilacji lokalnym clangiem

Gotowy obraz nie jest trzymany w git. Wydania GitHub powinny publikować go jako asset release:

- `kernelsu-boot.img`
- SHA256: `085689d5441c831d2f33a71c387f69fd4b00af12fe4e4c99ed042737cf611375`

## Flash

Na LG V30 klasyczny bootloader fastboot potrafi zrywać transfer. Użyj fastbootd:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-boot.img
fastboot reboot
```

KernelSU Manager: `v0.9.5 (11872)`.

## Przywracanie

Pobierz oryginalny `boot.img` z tego samego buildu LineageOS, z którego korzystasz, i wgraj go przez fastbootd:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```

## Build

Wymagane narzędzia: `clang`, `bc`, `make`, `mkbootimg`, `unpack_bootimg`, AArch64 cross compiler oraz ARM32 EABI linker dla compat vDSO.

```bash
./prepare-source.sh
./build-kernel.sh
cp /path/to/official/boot.img stock-boot.img
./repack-boot.sh
```

## Źródła i baza

- Kernel: `LineageOS/android_kernel_lge_msm8998` (`lineage-22.2`)
- KernelSU: `tiann/KernelSU` tag `v0.9.5`
- Oficjalny boot bazowy: `lineage-22.2-20260524-nightly-joan`
