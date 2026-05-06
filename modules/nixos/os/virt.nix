{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.my.os.virt;
in
{
  options.my.os.virt = {
    enable = lib.mkEnableOption "Virtualization stack for VMs (libvirt/qemu + virt-manager), suitable for Windows";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "alice"
        "bob"
      ];
      description = "Users to add to the 'kvm' and 'libvirtd' groups.";
    };

    tpm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable swtpm integration for libvirt/QEMU (useful for Windows 11).";
    };

    trustVirbr0 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add 'virbr0' to networking.firewall.trustedInterfaces.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = cfg.tpm;
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages =
      with pkgs;
      [
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
      ]
      ++ lib.optionals cfg.tpm [ pkgs.swtpm ];

    virtualisation.spiceUSBRedirection.enable = true;

    users.users = lib.genAttrs cfg.users (u: {
      extraGroups = [
        "kvm"
        "libvirtd"
      ];
    });

    networking.firewall.trustedInterfaces = lib.mkIf cfg.trustVirbr0 [ "virbr0" ];

    environment.persistence."/persist" = {
      directories = [
        "/var/lib/libvirt"
        "/etc/libvirt"

      ];
    };

  };

}
