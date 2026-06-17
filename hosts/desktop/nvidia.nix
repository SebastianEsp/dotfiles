{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Enable Nvidia Drivers
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.screenSection = ''
    Option         "DefaultDepth 24"
    Option         "metamodes" "DP-0: nvidia-auto-select +1080+0 {AllowGSYNCCompatible=On}, DP-2: 1920x1080_120 +0+0 {rotation=left}, DP-4: nvidia-auto-select +3640+0 {rotation=left}"
  '';

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaSettings = false;

  #hardware.nvidia.package = pkgs-unstable.linuxPackages.nvidiaPackages.latest;
  #hardware.nvidia.package = pkgs.linuxPackages.nvidiaPackages.latest;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "610.43.02";
    sha256_64bit = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
    sha256_aarch64 = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
    openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
    settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
    persistencedSha256 = "sha256:0nd0bf2s9b2ic8a0rcscddasddkryx2qf6mx4861bv44wblm513z";
  };
}
