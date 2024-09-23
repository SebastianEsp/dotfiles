# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    #./hyprland
    ./git
    ./direnv
    ./kitty
    ./zsh
    ./nvim
    #./ags
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "sebastian";
    homeDirectory = "/home/sebastian";
  };

  programs.firefox.package = (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped { };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    vscode
    spotifywm
    discord
    firefox
    python3
    appimage-run
    #antimicrox
    #blender
    elixir
    killall
    protonvpn-gui
    ranger
    xdotool
    insomnia
    gnumake
    libreoffice-qt
    mpv
    unzip
    unrar
    p7zip
    autoconf
    automake
    libtool
    gnum4
    gcc
    easyeffects
    kubectl
    kubernetes-helm
    go
    inotify-tools
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "SpaceMono" ]; })
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.fzf.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
