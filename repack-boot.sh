#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOCK_BOOT="${ROOT}/stock-boot.img"
KERNEL_IMAGE="${ROOT}/kernel/out/arch/arm64/boot/Image.gz-dtb"
OUT_BOOT="${ROOT}/kernelsu-boot.img"
WORK="${ROOT}/work/boot-repack"

if [[ ! -f "${STOCK_BOOT}" ]]; then
  echo "Missing stock boot image: ${STOCK_BOOT}" >&2
  exit 1
fi

if [[ ! -f "${KERNEL_IMAGE}" ]]; then
  echo "Missing built kernel image: ${KERNEL_IMAGE}" >&2
  echo "Run ./build-kernel.sh first." >&2
  exit 1
fi

rm -rf "${WORK}"
mkdir -p "${WORK}"

unpack_bootimg --boot_img "${STOCK_BOOT}" --out "${WORK}" --format mkbootimg -0 >"${WORK}/mkbootimg_args"

cp "${KERNEL_IMAGE}" "${WORK}/kernel"

declare -a MKBOOTIMG_ARGS=()
while IFS= read -r -d '' ARG; do
  MKBOOTIMG_ARGS+=("${ARG}")
done <"${WORK}/mkbootimg_args"

# Drop the unpacked kernel path from args; pass our rebuilt kernel explicitly.
filtered=()
skip_next=0
for arg in "${MKBOOTIMG_ARGS[@]}"; do
  if (( skip_next )); then
    skip_next=0
    continue
  fi
  if [[ "${arg}" == "--kernel" ]]; then
    skip_next=1
    continue
  fi
  filtered+=("${arg}")
done

mkbootimg "${filtered[@]}" --kernel "${WORK}/kernel" --output "${OUT_BOOT}"

echo "[+] Repacked boot image: ${OUT_BOOT}"
echo "[+] Header check:"
unpack_bootimg --boot_img "${OUT_BOOT}" --format info
echo
sha256sum "${OUT_BOOT}" "${STOCK_BOOT}"
