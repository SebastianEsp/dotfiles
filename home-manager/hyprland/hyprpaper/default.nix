{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        hyprpaper
    ];

  home.file."wallpaper_randomizer.sh".source = ./wallpaper_randomizer.sh;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;

}
