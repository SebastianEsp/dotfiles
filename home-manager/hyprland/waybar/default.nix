{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        waybar
    ];

    home.file.".config/waybar/theme.css".source = ./theme.css;
}
