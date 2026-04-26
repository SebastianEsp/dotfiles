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

  hardware.nvidia.package = pkgs-unstable.linuxPackages.nvidiaPackages.latest;
  #hardware.nvidia.package = pkgs.linuxPackages.nvidiaPackages.latest;

  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #  version = "575.51.02";
  #  sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
  #  sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
  #  openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
  #  settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
  #  persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
  #};
}
