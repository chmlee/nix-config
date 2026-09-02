#!/usr/bin/env bash
set -euo pipefail

repo_root="$(
  git rev-parse --show-toplevel
)"

cd "$repo_root"

out_link="$repo_root/result-trantor-install-test"

echo "Running Trantor Disko installation test..."

nix build -L \
  '.#nixosConfigurations.trantor-vm-test.config.system.build.installTest' \
  --out-link "$out_link"

echo
echo "Trantor installation test passed."
echo "Result: $(readlink -f "$out_link")"
