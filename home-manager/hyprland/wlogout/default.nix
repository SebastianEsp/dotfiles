{pkgs, inputs, hyprland, ...}: {

    home.packages = with pkgs; [
        wlogout
    ];

    home.file.".config/wlogout/layout".source = ./layout;
    home.file.".config/wlogout/style.css".source = ./style.css
};
