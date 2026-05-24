#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="${ROOT}/kernel"
OUT="${KERNEL_DIR}/out"

export ARCH=arm64
export SUBARCH=arm64

if ! command -v clang >/dev/null; then
  echo "Missing clang" >&2
  exit 1
fi

if ! command -v bc >/dev/null; then
  echo "Missing bc" >&2
  exit 1
fi

if command -v aarch64-linux-gnu-gcc >/dev/null; then
  export CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"
else
  echo "Missing aarch64-linux-gnu-gcc. Install an AArch64 cross compiler or set CROSS_COMPILE." >&2
  exit 1
fi

if [[ -z "${CROSS_COMPILE_ARM32:-}" ]]; then
  if command -v arm-linux-gnueabi-ld >/dev/null; then
    export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
  elif command -v arm-linux-ld >/dev/null; then
    export CROSS_COMPILE_ARM32=arm-linux-
  else
    echo "Missing ARM32 linker for compat vDSO. Install an ARM EABI toolchain or set CROSS_COMPILE_ARM32." >&2
    exit 1
  fi
fi

export CLANG_TRIPLE=aarch64-linux-gnu-
export CC=clang
export REAL_CC=clang

cd "${KERNEL_DIR}"

MAKE_COMMON=(
  O="${OUT}"
  CC=clang
  REAL_CC=clang
)

echo "[+] Configuring lineageos_joan_defconfig"
make "${MAKE_COMMON[@]}" lineageos_joan_defconfig

echo "[+] Building Image.gz-dtb (this can take a while)"
make "${MAKE_COMMON[@]}" -j"$(nproc)" Image.gz-dtb

echo "[+] Output: ${OUT}/arch/arm64/boot/Image.gz-dtb"
