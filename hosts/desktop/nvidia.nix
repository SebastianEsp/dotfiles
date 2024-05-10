{
  config,
  pkgs,
  ...
}: {
  # Enable Nvidia Drivers
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.screenSection = ''
    Option         "DefaultDepth 24"
    Option         "metamodes" "DP-0: nvidia-auto-select +1080+0 {AllowGSYNCCompatible=On}, DP-2: 1920x1080_120 +0+0 {rotation=left}, DP-4: nvidia-auto-select +3640+0 {rotation=left}"
  '';

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;

  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

  hardware.nvidia.package = let
    rcu_patch = pkgs.fetchpatch {
      url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
      hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
    };
  in
    config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #version = "535.154.05";
      #sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      #sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      #openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      #settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      #persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

      version = "550.40.07";
      sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
      sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
      openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
      settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
      persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";

      #version = "550.40.59";
      #persistencedVersion = "550.54.14";
      #settingsVersion = "550.54.14";
      #sha256_64bit = "sha256-hVwYC454vkxcK8I9bj1kp6iFS667em0c+Ral243C0J8=";
      #openSha256 = "sha256-/v1iVcmHhdvib54LDktNBHkcmgFxZVwQxwPdWSi0l/U=";
      #settingsSha256 = "sha256-m2rNASJp0i0Ez2OuqL+JpgEF0Yd8sYVCyrOoo/ln2a4=";
      #persistencedSha256 = "sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
      #url = "https://developer.nvidia.com/downloads/vulkan-beta-5504059-linux";

      patches = [rcu_patch];
    };
}
