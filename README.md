# LG V30 Root 2026 - KernelSU Next for joan / H930 LineageOS 22.2 Android 15

KernelSU Next reference build for the **LG V30** (`joan` / H930, msm8998) running **LineageOS 22.2 / Android 15**.

This tree targets the legacy **Linux 4.4.302 non-GKI** kernel. It intentionally avoids KernelSU Next's kprobe/kretprobe hook path and uses strict **manual hooks**, because kprobe-based VFS interception is too fragile on 4.4 under real I/O load.

Current build:

- KernelSU Next `legacy` @ `a54e4fa4` (`v3.2.0-legacy-14`, version `33193`)
- Includes the v3.3.0 backports that landed on `legacy` (SELinux hide, adb root, sulog)
- There is no `v3.3.0-legacy` tag yet; this is the newest non-GKI snapshot
- Previous `v3.2.0-legacy` image was verified with Zygisk Next, TrickyStore + FixIntegrity, and Play Integrity **BASIC + DEVICE**. Flash-test this rebuild on device before treating those as confirmed.

## LG V30 Root / KernelSU

This project is a modern LG V30 root method for `joan` / H930 on LineageOS 22.2 Android 15 using KernelSU Next.

Useful search terms: LG V30 root 2026, LG V30 KernelSU, LG V30 LineageOS 22.2 root, joan KernelSU, H930 root Android 15, msm8998 KernelSU Next.

## Files

This repository contains scripts and patches to reproduce the KernelSU Next-enabled kernel source:

- `prepare-source.sh` - clones the LineageOS kernel, integrates KernelSU Next, and applies local patches
- `build-kernel.sh` - builds `Image.gz-dtb`
- `repack-boot.sh` - repacks an official `boot.img` with the rebuilt kernel
- `patches/post-kernelsu.diff` - local build fixes and KernelSU defconfig changes
- `patches/manual-hooks-linux-4.4.diff` - strict Linux 4.4 manual hook integration
- `patches/kernelsu-next-linux-4.4-compat.diff` - `ALIGN_DOWN` / `__nocfi` fallbacks for Linux 4.4

The ready-to-flash image is not stored in git. GitHub releases should publish it as a release asset.

Current image:

- `kernelsu-next-boot.img`
- SHA256: `fe3c538e32a549f457643d158a49e17e07bc164659ab97d2ad39623d0bc10660`

## Why Manual Hooks

KernelSU Next can hook legacy kernels through kprobes/kretprobes, but this is not a good fit for the LG V30's 4.4 kernel. The stable path is to integrate the hooks directly into the syscall/VFS paths used by Android init and userspace.

The manual hook patch touches:

- `fs/exec.c` - `ksu_handle_execveat()` in `do_execveat_common()`
- `fs/read_write.c` - `ksu_handle_vfs_read()` in `vfs_read()`
- `fs/open.c` - `ksu_handle_faccessat()` in `faccessat`
- `fs/stat.c` - `ksu_handle_stat()`, `ksu_handle_newfstat_ret()`, and `ksu_handle_fstat64_ret()`
- `kernel/sys.c` - `ksu_handle_setresuid()` in `setresuid`
- `kernel/reboot.c` - `ksu_handle_sys_reboot()` in `reboot`
- `security/selinux/hooks.c` - allow the KernelSU `init -> ksu` transition

The `newfstat`/`fstat64` hooks are required for Android init to see the enlarged `init.rc` size. Without them, `post-fs-data` and `services` may not run, and Zygisk Next reports `could not connect to service`.

The SELinux hook is required because Android 15 denies the `init -> ksu` bounded transition when init tries to execute `/data/adb/ksud`. Without this, the kernel logs show:

```text
security_bounded_transition denied oldcontext=u:r:init:s0 newcontext=u:r:ksu:s0
init: cannot execv('/data/adb/ksud'): Permission denied
```

## Flash

On the LG V30, classic bootloader fastboot may disconnect while transferring the boot image. Use fastbootd:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-next-boot.img
fastboot reboot
```

KernelSU Next Manager: `v3.3.0 (33214)`.

## Rollback

Flash the saved legacy KernelSU image or the original `boot.img` from the same LineageOS build through fastbootd:

```bash
adb reboot fastboot
fastboot flash boot kernelsu-boot-v0.9.5.img
fastboot reboot
```

## Build

Required tools: `clang`, `bc`, `make`, `mkbootimg`, `unpack_bootimg`, an AArch64 cross compiler, and an ARM32 EABI linker such as `arm-none-eabi-binutils`.

```bash
./prepare-source.sh
./build-kernel.sh
cp /path/to/official/boot.img stock-boot.img
./repack-boot.sh
```

The build output used for repacking is:

```text
kernel/out/arch/arm64/boot/Image.gz-dtb
```

Expected KernelSU config:

```text
CONFIG_KSU=y
CONFIG_KSU_MANUAL_HOOK=y
# CONFIG_KSU_KPROBES_HOOK is not set
```

## Verification

After flashing and granting ADB shell root in KernelSU Next Manager:

```bash
adb shell 'su -c "id; /data/adb/ksud -V; /data/adb/ksud module list"'
adb shell 'ps -A | grep -iE "zn-daemon|zn-nsdaemon|TrickyStore"'
```

Healthy Zygisk output includes:

```text
zn-daemon
zn-nsdaemon-zygote
zn-nsdaemon-zygote_secondary
TrickyStore
```

## Sources and Base

- Kernel: `LineageOS/android_kernel_lge_msm8998` (`lineage-22.2`)
- KernelSU Next: `KernelSU-Next/KernelSU-Next` branch `legacy` @ `a54e4fa4` (`v3.2.0-legacy-14`, `33193`)
- Official base boot image: `lineage-22.2-20260816-nightly-joan`
