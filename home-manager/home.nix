# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./hyprland
    ./git
    ./direnv
    ./kitty
    ./zsh
    ./nvim
    ./helix
    ./scripts
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

  #programs.firefox.package = 
  programs.java = { enable = true; package = (pkgs.jdk21.override { enableJavaFX = true; }); };
  #quickshell = inputs.quickshell.packages.${pkgs.system}.default;


  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    #Gaming
    wowup-cf
    runelite
    prismlauncher

    #Programming
    go
    gcc
    selenium-server-standalone
    geckodriver
    google-chrome
    chromedriver
    python3
    elixir
    zed-editor

    #Quickshell
    inputs.quickshell.packages.${pkgs.system}.default

    nomachine-client

    rclone
    jq
    envsubst 
    vscode
    spotifywm
    discord
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})

    appimage-run
    #antimicrox
    blender
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
    easyeffects
    kubectl
    kubernetes-helm
    inotify-tools
    sops
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.space-mono
    ftb-app
    openconnect
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
