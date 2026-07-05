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
    version = "595.84";
    sha256_64bit = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
    sha256_aarch64 = "sha256-pEmA2tUcOKwUPKy6N0QvS49Pdut4/7Phs/JhjdyBcNY=";
    openSha256 = "sha256-pEmA2tUcOKwUPKy6N0QvS49Pdut4/7Phs/JhjdyBcNY=";
    settingsSha256 = lib.fakeHash;
    persistencedSha256 = lib.fakeHash;
  };
}
