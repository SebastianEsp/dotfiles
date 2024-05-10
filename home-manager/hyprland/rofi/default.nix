{
  config,
  pkgs,
  ...
}: {
  #programs.rofi.enable = true;

  home.packages = with pkgs; [
    rofi-wayland
  ];

  home.file.".config/rofi/rounded-red-dark.rasi".source = ./rounded-red-dark.rasi;
  home.file.".config/rofi/rounded-common.rasi".source = ./rounded-common.rasi;
}
