# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./nvidia.nix
    ./bootloader.nix
    ./polkit.nix
    ./mounts.nix
    ./users.nix
    ./virtualization.nix
    ./networking.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelModules = [ "uhid" "uinput" ];
  boot.kernelPatches = lib.singleton {
    name = "enable-uhid";
    patch = null;
    extraStructuredConfig = with lib.kernel; {
      HID = yes;
      UHID = yes;
      INPUT_UINPUT = yes;
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8812au
  ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";
  #time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.utf8";

  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Enable bluetooth
  #hardware.bluetooth.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        UserspaceHID = true;
        Experimental = true;
      };
    };
  };


  hardware.xpadneo.enable = true;

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;

  # Set default shell
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.teamviewer.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    joycond
    samba
    cifs-utils
    openssl
    powershell
    winetricks
    lxqt.lxqt-policykit
    appimagekit
    networkmanagerapplet
    dotnetCorePackages.sdk_9_0
    unityhub
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages

  ];

  programs.gamemode.enable = true;

  system.stateVersion = "24.05";
}
