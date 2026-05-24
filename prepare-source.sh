#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="${ROOT}/kernel"
KERNEL_REPO="${KERNEL_REPO:-https://github.com/LineageOS/android_kernel_lge_msm8998.git}"
KERNEL_BRANCH="${KERNEL_BRANCH:-lineage-22.2}"
KSU_REF="${KSU_REF:-v0.9.5}"

if [[ -e "${KERNEL_DIR}" ]]; then
  echo "Refusing to overwrite existing ${KERNEL_DIR}" >&2
  exit 1
fi

echo "[+] Cloning ${KERNEL_REPO} (${KERNEL_BRANCH})"
git clone --depth 1 -b "${KERNEL_BRANCH}" "${KERNEL_REPO}" "${KERNEL_DIR}"

echo "[+] Integrating KernelSU ${KSU_REF}"
(
  cd "${KERNEL_DIR}"
  curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s "${KSU_REF}"
)

echo "[+] Applying local post-KernelSU patches"
patch -d "${KERNEL_DIR}" -p1 < "${ROOT}/patches/post-kernelsu.diff"

echo "[+] Source prepared in ${KERNEL_DIR}"
