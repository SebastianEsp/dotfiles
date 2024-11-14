{pkgs, inputs, ...}: {

    home.packages = with pkgs; [
        rofi-wayland
    ];

    home.file."rofilaunch.sh".source = ./rofilaunch.sh;
}
