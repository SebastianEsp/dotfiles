{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        hypridle
        brightnessctl
    ];

    home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
}
