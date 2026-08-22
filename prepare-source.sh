#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="${ROOT}/kernel"
KERNEL_REPO="${KERNEL_REPO:-https://github.com/LineageOS/android_kernel_lge_msm8998.git}"
KERNEL_BRANCH="${KERNEL_BRANCH:-lineage-22.2}"
# KernelSU Next ref for non-GKI 4.4.x. There is no v3.3.0-legacy tag yet;
# pin the latest legacy commit (14 commits past v3.2.0-legacy) instead of
# the rolling branch name so rebuilds stay reproducible.
KSU_REF="${KSU_REF:-a54e4fa46c6cc25bcaa055cf14d790194beffed8}"

if [[ -e "${KERNEL_DIR}" ]]; then
  echo "Refusing to overwrite existing ${KERNEL_DIR}" >&2
  exit 1
fi

echo "[+] Cloning ${KERNEL_REPO} (${KERNEL_BRANCH})"
git clone --depth 1 -b "${KERNEL_BRANCH}" "${KERNEL_REPO}" "${KERNEL_DIR}"

echo "[+] Integrating KernelSU Next (${KSU_REF})"
(
  cd "${KERNEL_DIR}"
  curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s "${KSU_REF}"
)

echo "[+] Applying local post-KernelSU Next patches"
patch -d "${KERNEL_DIR}" -p1 < "${ROOT}/patches/post-kernelsu.diff"
patch -d "${KERNEL_DIR}" -p1 < "${ROOT}/patches/manual-hooks-linux-4.4.diff"
patch -d "${KERNEL_DIR}/KernelSU-Next" -p1 < "${ROOT}/patches/kernelsu-next-linux-4.4-compat.diff"

echo "[+] Source prepared in ${KERNEL_DIR}"
