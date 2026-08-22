## Summary

KernelSU Next manual-hooks boot image for LG V30 H930 (`joan`) on LineageOS 22.2 nightly `20260816`.

- KernelSU Next `legacy` @ `a54e4fa4` (`v3.2.0-legacy-14`, `33193`) for non-GKI Linux 4.4
- No `v3.3.0-legacy` tag exists; this is the newest legacy snapshot and includes the v3.3.0 backports
- Based on LineageOS `android_kernel_lge_msm8998` branch `lineage-22.2`
- Strict manual hooks; KernelSU kprobes/kretprobes are disabled
- Previous `v3.2.0-legacy` image had Zygisk Next, TrickyStore + FixIntegrity, and Play Integrity BASIC + DEVICE. Re-verify after flashing this rebuild.
- Legacy KernelSU `v0.9.5` image is kept as a rollback option

## Assets

- `kernelsu-next-boot.img`
- `kernelsu-next-boot.img.sha256`
- optional rollback: `kernelsu-boot-v0.9.5.img`
- optional rollback SHA256: `kernelsu-boot-v0.9.5.img.sha256`

SHA256:

```text
fe3c538e32a549f457643d158a49e17e07bc164659ab97d2ad39623d0bc10660  kernelsu-next-boot.img
```

## Flash

Use fastbootd, not classic bootloader fastboot:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-next-boot.img
fastboot reboot
```

Install KernelSU Next Manager `v3.3.0 (33214)`.

## Rollback

Flash the official `boot.img` from the same LineageOS build:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```
