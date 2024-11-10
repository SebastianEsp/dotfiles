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
}
