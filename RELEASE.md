# Release Notes - v0.9.5-joan-20260524

## Target

- Device: LG V30 H930 (`joan`)
- ROM: LineageOS 22.2 nightly `20260524`
- Kernel: Linux `4.4.302-perf+`
- KernelSU: `v0.9.5 (11872)`
- SELinux: Enforcing

## Assets

Upload these files to the GitHub Release, not to git history:

- `kernelsu-boot.img`
- `kernelsu-boot.img.sha256`

Current SHA256:

```text
085689d5441c831d2f33a71c387f69fd4b00af12fe4e4c99ed042737cf611375  kernelsu-boot.img
```

## Install

Use fastbootd. Classic bootloader fastboot can disconnect on this device while sending `boot.img`.

```bash
adb reboot fastboot
fastboot flash boot kernelsu-boot.img
fastboot reboot
```

Install KernelSU Manager `v0.9.5 (11872)`. Do not update to newer manager builds on this non-GKI 4.4 kernel.

## Rollback

Download the official `boot.img` from the matching LineageOS build and flash it through fastbootd:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```

## Known Notes

- This is not a GKI kernel.
- The manager may show that a newer KernelSU version exists; ignore it for this device.
- `fastboot boot kernelsu-boot.img` is not recommended on LG V30.
