# LG V30 (joan / H930) - KernelSU

Kernel with **KernelSU v0.9.5** (kprobe) for **LineageOS 22.2** (`lineage-22.2-20260524-nightly-joan`) on the LG V30 `joan` / H930.

This build targets the legacy **Linux 4.4.302 non-GKI** kernel. Do not update KernelSU Manager from the in-app update banner; stay on **v0.9.5 (11872)**.

## Files

This repository contains scripts and patches to reproduce the KernelSU-enabled kernel source:

- `prepare-source.sh` - clones the LineageOS kernel, integrates KernelSU, and applies local patches
- `build-kernel.sh` - builds `Image.gz-dtb`
- `repack-boot.sh` - repacks an official `boot.img` with the rebuilt kernel
- `patches/` - small fixes needed for local clang builds

The ready-to-flash image is not stored in git. GitHub releases should publish it as a release asset:

- `kernelsu-boot.img`
- SHA256: `085689d5441c831d2f33a71c387f69fd4b00af12fe4e4c99ed042737cf611375`

## Flash

On the LG V30, classic bootloader fastboot may disconnect while transferring the boot image. Use fastbootd:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-boot.img
fastboot reboot
```

KernelSU Manager: `v0.9.5 (11872)`.

## Rollback

Download the original `boot.img` from the same LineageOS build you are using and flash it through fastbootd:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```

## Build

Required tools: `clang`, `bc`, `make`, `mkbootimg`, `unpack_bootimg`, an AArch64 cross compiler, and an ARM32 EABI linker for compat vDSO.

```bash
./prepare-source.sh
./build-kernel.sh
cp /path/to/official/boot.img stock-boot.img
./repack-boot.sh
```

## Sources and Base

- Kernel: `LineageOS/android_kernel_lge_msm8998` (`lineage-22.2`)
- KernelSU: `tiann/KernelSU` tag `v0.9.5`
- Official base boot image: `lineage-22.2-20260524-nightly-joan`
