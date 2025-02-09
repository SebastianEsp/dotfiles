{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        waybar
    ];

    home.file.".config/waybar/assets".source = ./assets;
    home.file."playerctl.sh".source = ./modules/playerctl/playerctl.sh;
    home.file.".config/waybar/style.css".source = ./style.css;
    home.file.".config/waybar/config.jsonc".source = ./config.jsonc;
}
