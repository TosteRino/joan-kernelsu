# Release Notes - kernelsu-next-joan-20260822

## Target

- Device: LG V30 H930 (`joan`)
- ROM: LineageOS 22.2 nightly `20260816`
- Kernel: Linux `4.4.302-perf+`
- KernelSU Next: `legacy` @ `a54e4fa4` (`v3.2.0-legacy-14`, version `33193`)
- Hook mode: manual hooks for Linux 4.4
- SELinux: Enforcing

There is no `v3.3.0-legacy` tag. This build uses the newest `legacy` commit, which already carries the v3.3.0 backports (SELinux hide, adb root, sulog).

## Assets

Upload these files to the GitHub Release, not to git history:

- `kernelsu-next-boot.img`
- `kernelsu-next-boot.img.sha256`
- optional rollback: `kernelsu-boot-v0.9.5.img`
- optional rollback SHA256: `kernelsu-boot-v0.9.5.img.sha256`

Current SHA256:

```text
fe3c538e32a549f457643d158a49e17e07bc164659ab97d2ad39623d0bc10660  kernelsu-next-boot.img
085689d5441c831d2f33a71c387f69fd4b00af12fe4e4c99ed042737cf611375  kernelsu-boot-v0.9.5.img
```

## Install

Use fastbootd. Classic bootloader fastboot can disconnect on this device while sending `boot.img`.

```bash
adb reboot fastboot
fastboot flash boot kernelsu-next-boot.img
fastboot reboot
```

Install KernelSU Next Manager `v3.3.0 (33214)`.

## Rollback

Download the official `boot.img` from the matching LineageOS build and flash it through fastbootd:

```bash
adb reboot fastboot
fastboot flash boot boot.img
fastboot reboot
```

## Known Notes

- This is not a GKI kernel.
- Upstream `tiann/KernelSU` is capped at `v0.9.5` for this kernel; the current build uses KernelSU Next `legacy` instead.
- This build uses KernelSU manual hooks, not KernelSU kprobes/kretprobes.
- Zygisk Next, TrickyStore, and FixIntegrity were verified on the previous `v3.2.0-legacy` image with BASIC + DEVICE Play Integrity. Re-check them after flashing this rebuild.
- `fastboot boot kernelsu-next-boot.img` is not recommended on LG V30; flash through fastbootd.
