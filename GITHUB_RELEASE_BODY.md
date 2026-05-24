## Summary

KernelSU boot image for LG V30 H930 (`joan`) on LineageOS 22.2 nightly `20260524`.

- KernelSU `v0.9.5 (11872)` for non-GKI Linux 4.4
- Based on LineageOS `android_kernel_lge_msm8998` branch `lineage-22.2`
- Verified booting on LG-H930 with KernelSU Manager reporting active root

## Assets

- `kernelsu-boot.img`
- `kernelsu-boot.img.sha256`

SHA256:

```text
085689d5441c831d2f33a71c387f69fd4b00af12fe4e4c99ed042737cf611375  kernelsu-boot.img
```

## Flash

Use fastbootd, not classic bootloader fastboot:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-boot.img
fastboot reboot
```

Install KernelSU Manager `v0.9.5 (11872)` and do not update it to newer manager builds for this device.

## Rollback

Flash the official `boot.img` from the same LineageOS build:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```
