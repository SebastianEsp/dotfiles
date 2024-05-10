{ config, pkgs, ... }:

{
  # kitty configuration
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Fira Code Regular Nerd Font Complete Mono";
      inactive_text_alpha = "0.6";
    };
    theme = "Doom One";
    #font.package = pkgs.nerdfonts;
  };
}


