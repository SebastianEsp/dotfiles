{pkgs, inputs, ...}: {

    home.packages = with pkgs; [
        rofi-wayland
    ];

    home.file.".config/rofi/styles".source = ./styles;
    home.file."rofilaunch.sh".source = ./rofilaunch.sh;
}
