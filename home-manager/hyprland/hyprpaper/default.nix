{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        hyprpaper
    ];

  home.file."wallpaper_randomizer.sh".source = ./wallpaper_randomizer.sh;

}
