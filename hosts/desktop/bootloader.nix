{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #boot.loader.grub.enable = true;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.grub.extraEntries = ''
  #  menuentry "windows" --class windows --class os {
  #  insmod part_gpt
  #  insmod fat
  #  insmod search_fs_uuid
  #  insmod chain
  #  search --fs-uuid --set=root A3C3-042C
  #  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #  }
  #'';
}
