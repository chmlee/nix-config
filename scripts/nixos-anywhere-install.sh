#!/usr/bin/env bash
set -euo pipefail

host="${1:?usage: scripts/nixos-anywhere-install.sh <flake-host> <ip-or-host>}"
target="${2:?usage: scripts/nixos-anywhere-install.sh <flake-host> <ip-or-host>}"

ssh_key="${SSH_KEY:-$HOME/.ssh/id_ed25519}"

tmp_os_key=""
tmp_data_key=""
tmp_extra_files=""

cleanup() {
  for key in "${tmp_os_key:-}" "${tmp_data_key:-}"; do
    if [[ -n "$key" && -f "$key" ]]; then
      shred -u "$key" 2>/dev/null || rm -f "$key"
    fi
  done

  if [[ -n "${tmp_extra_files:-}" && -d "$tmp_extra_files" ]]; then
    rm -rf "$tmp_extra_files"
  fi
}

trap cleanup EXIT

args=(
  --flake ".#$host"
  --kexec-extra-flags "--kexec-syscall"
  --ssh-option "IdentityFile=$ssh_key"
  --ssh-option "IdentitiesOnly=yes"
)

case "$host" in
  trantor)
    tmp_os_key="$(mktemp)"
    tmp_data_key="$(mktemp)"

    sops -d --extract '["trantor"]["luks"]["os_key"]' secrets.yaml > "$tmp_os_key"
    sops -d --extract '["trantor"]["luks"]["data_key"]' secrets.yaml > "$tmp_data_key"

    chmod 600 "$tmp_os_key" "$tmp_data_key"

    tmp_extra_files="$(mktemp -d)"
    install -d -m 755 "$tmp_extra_files/etc/ssh"

    sops -d --extract '["trantor"]["initrd_ssh_host_ed25519_key"]' secrets.yaml \
      > "$tmp_extra_files/etc/ssh/initrd_ssh_host_ed25519_key"

    chmod 600 "$tmp_extra_files/etc/ssh/initrd_ssh_host_ed25519_key"

    args+=(
      --disk-encryption-keys /tmp/disko-os.key "$tmp_os_key"
      --disk-encryption-keys /tmp/disko-data.key "$tmp_data_key"
      --extra-files "$tmp_extra_files"
    )
    ;;
esac

echo "Installing NixOS host '$host' to root@$target"
echo "Using SSH key: $ssh_key"
echo
echo "WARNING: nixos-anywhere + disko may wipe disks on the target."
read -r -p "Continue? [y/N] " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 1
fi

NIX_SSHOPTS="-i $ssh_key -o IdentitiesOnly=yes" \
nix run github:nix-community/nixos-anywhere -- \
  "${args[@]}" \
  "root@$target"
