{ config, pkgs, ... }:

{
  programs.noctalia = {
    enable = true;

    settings = (builtins.fromTOML (builtins.readFile ./bar.toml)) // {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/path/to/wallpapers/wallpaper.png";
      };
    };
  };
}
