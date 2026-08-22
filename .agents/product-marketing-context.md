# joan-kernelsu — Context

- **What it is:** KernelSU Next manual-hooks kernel and boot image for LG V30 (`joan` / H930) on LineageOS 22.2 / Android 15.
- **Who it's for:** People already running matching LineageOS 22.2 joan nightlies who want KernelSU Next root (not Magisk, not stock LG).
- **Key differentiator:** Linux 4.4.302 non-GKI cannot use kprobes safely here; hooks are patched into VFS/syscall/SELinux paths.
- **Current stage:** Public GitHub repo + Releases + Pages landing.
- **Current goals:** Keep the boot image matched to the latest joan nightly, pin a reproducible KernelSU Next `legacy` commit, don't brick people with stock firmware flashes.

## Positioning

LG V30 root 2026 via KernelSU Next, not a generic KernelSU port. Talk device-first (`joan` / H930), then ROM (`lineage-22.2-YYYYMMDD-nightly-joan`), then hook mode (manual).

## Constraints

- Flash **fastbootd** (`adb reboot fastboot`), not classic bootloader fastboot.
- Matching LineageOS 22.2 joan only. Never stock LG firmware.
- Ready-to-flash `*.img` stays out of git; GitHub Release assets only.
- Manager APK: KernelSU Next **v3.3.0 (33214)** for the current kernel version **33193**.
- Landing is vibecoded; the kernel tree is not.
