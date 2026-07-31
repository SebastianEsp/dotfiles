{...}: {
  fileSystems."/home/sebastian/nas/admin" = {
    device = "//192.168.1.120/admin";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/home/sebastian/dotfiles/smb-secrets,vers=1.0,uid=sebastian,gid=users"];
  };

  fileSystems."/home/sebastian/nas/video" = {
    device = "//192.168.1.120/video";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/home/sebastian/dotfiles/smb-secrets,vers=1.0,uid=sebastian,gid=users"];
  };

  # NVMe games drive — mounted declaratively at boot so Steam always finds
  # its library. Same path udisks2 used previously, to keep Steam's registered
  # library paths intact. nofail keeps boot from hanging if the disk is absent.
  fileSystems."/run/media/sebastian/NVME Storage" = {
    device = "/dev/disk/by-uuid/d54c22aa-38d8-4356-8f36-700cd9e8a6fd";
    fsType = "ext4";
    options = ["nofail" "x-systemd.device-timeout=5s"];
  };
}
