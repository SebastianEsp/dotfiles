{
  config,
  lib,
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
    version = "610.57.04";
    sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
    sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
    openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
    settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
    persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
  };
}
