{inputs, pkgs, pkgs-unstable, ...}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    #withUWSM  = true;
  };

  #programs.uwsm.enable = true;

  programs.dconf.enable = true;
  programs.nm-applet.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}