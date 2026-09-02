#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 [--fresh]" >&2
}

fresh=false

case "${1:-}" in
  "")
    ;;
  --fresh)
    fresh=true
    ;;
  *)
    usage
    exit 2
    ;;
esac

repo_root="$(
  git rev-parse --show-toplevel
)"

cd "$repo_root"

out_link="$repo_root/result-trantor-vm"
disk_directory="$repo_root/.vm"
disk_image="$disk_directory/trantor.qcow2"

mkdir -p "$disk_directory"

if "$fresh"; then
  echo "Removing previous VM state: $disk_image"
  rm -f "$disk_image"
fi

echo "Building interactive Trantor VM..."

nix build -L \
  '.#nixosConfigurations.trantor-vm-test.config.system.build.vm' \
  --out-link "$out_link"

shopt -s nullglob
runners=(
  "$out_link"/bin/run-*-vm
)
shopt -u nullglob

if (( ${#runners[@]} != 1 )); then
  echo "Expected exactly one VM runner under $out_link/bin." >&2
  exit 1
fi

echo "Starting Trantor VM."
echo "Disk image: $disk_image"

export NIX_DISK_IMAGE="$disk_image"

exec "${runners[0]}"
