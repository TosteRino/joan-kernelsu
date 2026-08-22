# KernelSU Next on joan

## 2026-08-22 — Latest legacy rebuild

- There is **no** `v3.3.0-legacy` tag. Newest non-GKI is rolling `legacy`.
- Pinned: `a54e4fa46c6cc25bcaa055cf14d790194beffed8` (`v3.2.0-legacy-14`, version **33193**).
- Base boot: official LineageOS `20260816` joan `boot.img` (OS patch 2026-08). Ramdisk SHA matched May; kernel source `lineage-22.2` had **0 commits** since May.
- Local 4.4 compat: `ALIGN_DOWN` + `__nocfi` in `patches/kernelsu-next-linux-4.4-compat.diff`.
- Manual hooks stay in `do_execveat_common`, `vfs_read`, `faccessat`, `vfs_fstatat` + `newfstat`/`fstat64` returns, `setresuid`, `reboot`, SELinux `is_ksu_transition`.
- Do **not** switch back to kprobes. Optional later: volume-down safe-mode hook in `drivers/input/input.c`.
- Release: https://github.com/TosteRino/joan-kernelsu/releases/tag/kernelsu-next-joan-20260822
- SHA256 `kernelsu-next-boot.img`: `fe3c538e32a549f457643d158a49e17e07bc164659ab97d2ad39623d0bc10660`
