#!/usr/bin/env bash
set -euo pipefail

target="${1:?usage: scripts/unlock-trantor-initrd.sh <ip-or-host>}"

ssh_key="${SSH_KEY:-$HOME/.ssh/id_ed25519}"

tmp_os_key="$(mktemp)"
tmp_data_key="$(mktemp)"

cleanup() {
  shred -u "$tmp_os_key" "$tmp_data_key" 2>/dev/null || rm -f "$tmp_os_key" "$tmp_data_key"
}
trap cleanup EXIT

sops -d --extract '["trantor"]["luks"]["os_key"]' secrets.yaml > "$tmp_os_key"
sops -d --extract '["trantor"]["luks"]["data_key"]' secrets.yaml > "$tmp_data_key"

chmod 600 "$tmp_os_key" "$tmp_data_key"

echo "Connecting to initrd SSH on root@$target:2222"
echo
echo "If automatic unlock fails, run manually:"
echo "  cryptsetup-askpass"
echo
echo "OS key:"
cat "$tmp_os_key"
echo
echo "Data key:"
cat "$tmp_data_key"
echo

ssh \
  -i "$ssh_key" \
  -o IdentitiesOnly=yes \
  -p 2222 \
  "root@$target"
