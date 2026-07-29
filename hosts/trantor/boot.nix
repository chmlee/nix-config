{ config, lib, ... }:

let
  # Reuse the device selected by disk/system.nix.
  systemDisk = config.disko.devices.disk.system.device;

  # Dedicated SSH host key for the SSH server running inside the initrd.
  initrdHostKey = "/etc/secrets/initrd/ssh_host_ed25519_key";

  # This public key is safe to commit. It should be the public half of your
  # laptop's dedicated infrastructure SSH identity.
  infrastructurePublicKey = lib.removeSuffix "\n" (builtins.readFile ./keys/t14p-infra.pub);
in
{
  boot = {
    loader = {
      grub = {
        enable = true;

        # Install GRUB onto the same disk Disko defines as the system disk.
        devices = [ systemDisk ];

        # Support both firmware modes represented by disk/system.nix:
        #
        # - BIOS uses the EF02 partition.
        # - UEFI uses the EFI System Partition mounted at /boot.
        efiSupport = true;

        # Install the fallback UEFI executable at EFI/BOOT/BOOTX64.EFI.
        #
        # This avoids depending on firmware NVRAM entries surviving or being
        # writable on the Hetzner virtual machine.
        efiInstallAsRemovable = true;

        # Prevent old NixOS generations from eventually filling /boot.
        configurationLimit = 10;
      };

      efi = {
        # Required when GRUB is installed as the removable/fallback loader.
        canTouchEfiVariables = false;

        # Must match the mount point declared in disk/system.nix.
        efiSysMountPoint = "/boot";
      };
    };

    initrd = {
      # Use systemd-based stage 1 explicitly instead of relying on the
      # nixpkgs release default.
      systemd = {
        enable = true;

        network = {
          enable = true;

          networks."10-uplink" = {
            # Match common predictable and legacy Ethernet interface names,
            # such as ens3, enp1s0, or eth0.
            matchConfig.Name = "en* eth*";

            # IPv4 DHCP is sufficient to make initrd SSH reachable.
            networkConfig.DHCP = "ipv4";

            # Consider the interface online only after it has a routable
            # address rather than merely having a carrier.
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };

      network.ssh = {
        enable = true;
        port = 2222;

        # The NixOS initrd SSH module copies this dedicated host key into
        # the initrd. Never use the normal OpenSSH host key here.
        hostKeys = [ initrdHostKey ];

        authorizedKeys = [
          ''
            command="systemctl default",no-agent-forwarding,no-port-forwarding,no-X11-forwarding,no-user-rc ${infrastructurePublicKey}
          ''
        ];
      };
    };
  };
}
