{pkgs, pkgs-unstable, inputs, hyprland, ...}: {
  imports = [
    #./waybar
    #./wlogout
    #./rofi
    ./hyprpaper
    ./hypridle
  ];

  # allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";

    # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
    "LIBVA_DRIVER_NAME" = "nvidia";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_EGL_NO_MODIFIRES" = "1";
    "__GL_GSYNC_ALLOWED" = "1";
    "__GL_VRR_ALLOWED"= "1";
  };

  home.packages = with pkgs; [
    swaynotificationcenter
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    qt5.qtwayland
    qt6.qtwayland
    hyprshot
    hyprpolkitagent
    overskride
    pwvucontrol
  ];

  xdg.configFile."hypr/config.lua".source = ./config.lua;

  systemd.user.services.firefox-graceful-stop = {
    Unit = {
      Description = "Gracefully stop Firefox on graphical session end";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = let
        stopScript = pkgs.writeShellScript "firefox-graceful-stop" ''
          ${pkgs.procps}/bin/pkill --signal SIGTERM -x firefox || true
          for i in $(${pkgs.coreutils}/bin/seq 1 30); do
            ${pkgs.procps}/bin/pgrep -x firefox > /dev/null 2>&1 || exit 0
            ${pkgs.coreutils}/bin/sleep 0.5
          done
          ${pkgs.procps}/bin/pkill --signal SIGKILL -x firefox || true
        '';
      in "${stopScript}";
      TimeoutStopSec = 20;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  wayland.windowManager.hyprland = {

    enable = true;

    package = null;
    portalPackage = null;

    configType = "lua";

    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus
    ];

    extraConfig = builtins.readFile ./config.lua;
  };

}
