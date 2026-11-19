#!/usr/bin/env bash
# Build one firmware target in the pinned container.
# Usage: docker/build.sh [pio-env]   (default: WioTrackerL1_companion_radio_ble)
# Needs FIRMWARE_VERSION in the environment or defaults to the nearest companion tag.
# Output: out/<env>-<version>-<sha>.uf2 and a .sha256 next to it.
set -euo pipefail
here=$(cd "$(dirname "$0")/.." && pwd)
env_name=${1:-WioTrackerL1_companion_radio_ble}
image=meshcore-build:pio-6.2.0
pio_dir=${PIO_CORE_DIR:-$here/../pio}

version=${FIRMWARE_VERSION:-$(git -C "$here" describe --tags --abbrev=0 --match 'companion-v*' | sed 's/^companion-//')}
# Build date comes from the commit, so the same commit gives the same binary on any day.
epoch=$(git -C "$here" log -1 --format=%ct)

mkdir -p "$pio_dir" "$here/out"
docker build -q -t "$image" "$here/docker" >/dev/null
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$here:/src" -v "$pio_dir:/pio" \
  -e FIRMWARE_VERSION="$version" -e SOURCE_DATE_EPOCH="$epoch" \
  "$image" bash build.sh build-firmware "$env_name"

for f in "$here"/out/"$env_name"-"$version"-*.uf2; do
  sha256sum "$f" | tee "$f.sha256"
done
