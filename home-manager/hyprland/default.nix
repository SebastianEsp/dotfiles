{pkgs, inputs, hyprland, ...}: {
  imports = [
    ./waybar
    ./wlogout
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
  ];

  wayland.windowManager.hyprland = {

    enable = true;

    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus
    ];

    extraConfig = ''

      input {
        kb_layout = us,dk
        kb_options = grp:alt_shift_toggle
        accel_profile = flat
        sensitivity = 0.5 
      }

      #exec-once = nm-applet
      #exec-once = waybar
      exec-once = [workspace special silent] kitty
      exec-once = [workspace 1 silent] kitty
      #exec-once = [workspace 1 silent] firefox --class ff0
      #exec-once = [workspace 9 silent] firefox --class ff2
      #exec-once = [workspace 10 silent] firefox --class ff1
      #exec-once = easyeffects
      exec-once = [workspace 10 silent] discord --use-gl=desktop
      exec-once = [workspace 10 silent] spotify
      exec-once = swaync
      exec-once = [workspace 3 silent] steam -silent

      # Monitor rules
      monitor = DP-2, 1920x1080, 3640x0, 1, transform, 1
      monitor = DP-1, 2560x1440@144, 1080x52, 1, bitdepth, 10, vrr, 2
      monitor = DP-3, 1920x1080@120, 0x0, 1, transform, 1
      monitor = , preferred, auto, 1 #default rule

      # Keybinds
      bind = SUPER, Return, exec, kitty
      #bind = SUPER, f, exec, firefox
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      # Volume knob
      bind = , xf86audioraisevolume, exec, wpctl set-sink-volume @DEFAULT_SINK@ +5%     
      bind = , xf86audiolowervolume, exec, wpctl set-sink-volume @DEFAULT_SINK@ -5%
      bind = , xf86audiomute, exec, wpctl set-mute @DEFAULT_SINK@ toggle
      # Swaync
      bind = SUPER, n, exec, swaync-client -t -sw
      # wlogout
      bind = SUPER, l, exec, ~/logoutlaunch.sh
      bind = SUPER SHIFT, Return, togglespecialworkspace, 
      bind = SUPER, f, fullscreen

      # Move focus with arrow keys
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d
      
      # Switch workspaces with CTRL + arrow keys
      bind = CTRL, left, workspace, m-1
      bind = CTRL, right, workspace, m+1

      # Switch workspaces with SUPER + [0-9]
      bind = CTRL, 1, workspace, 1
      bind = CTRL, 2, workspace, 2
      bind = CTRL, 3, workspace, 3
      bind = CTRL, 4, workspace, 4
      bind = CTRL, 5, workspace, 5
      bind = CTRL, 6, workspace, 6
      bind = CTRL, 7, workspace, 7
      bind = CTRL, 8, workspace, 8
      bind = CTRL, 9, workspace, 9
      bind = CTRL, 0, workspace, 10

      # Move active window to a workspace with SUPER + SHIFT + [0-9]
      bind = CTRL SHIFT, 1, movetoworkspace, 1
      bind = CTRL SHIFT, 2, movetoworkspace, 2
      bind = CTRL SHIFT, 3, movetoworkspace, 3
      bind = CTRL SHIFT, 4, movetoworkspace, 4
      bind = CTRL SHIFT, 5, movetoworkspace, 5
      bind = CTRL SHIFT, 6, movetoworkspace, 6
      bind = CTRL SHIFT, 7, movetoworkspace, 7
      bind = CTRL SHIFT, 8, movetoworkspace, 8
      bind = CTRL SHIFT, 9, movetoworkspace, 9
      bind = CTRL SHIFT, 0, movetoworkspace, 10
      bind = CTRL ALT, left, movetoworkspace, -1
      bind = CTRL ALT, right, movetoworkspace, +1

      # Other keybinds
      bind = SUPER, s, togglefloating
      bind = SUPER, q, killactive
      bind = SUPER, space, exec, rofi -show drun -theme ~/.config/rofi/rounded-red-dark.rasi    

      # Workspace rules
      workspace = 1, monitor:DP-1, default:true
      workspace = 2, monitor:DP-1
      workspace = 3, monitor:DP-1
      workspace = 9, monitor:DP-2, gapsout:0, default:true, layoutopt:orientation:top
      workspace = 10, monitor:DP-3, gapsout:0, default:true, layoutopt:orientation:top

      # Window rules
      windowrule = workspace 1, kitty
      windowrule = workspace 1, class:ff0
      windowrule = workspace 3, steam
      windowrule = workspace 9, class:ff2
      windowrule = workspace 10, class:ff1
      windowrule = workspace 10, discord, float
      windowrule = workspace 10, spotify, float
    '';
  };

} 