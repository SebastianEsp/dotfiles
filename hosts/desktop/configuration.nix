# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
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

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  boot.kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelModules = [ "uhid" "uinput" ];
  boot.blacklistedKernelModules = ["hid_logitech_dj" "hid_logitech_hidpp"];
  #boot.kernelPackages = pkgs.linuxPackages_6_12;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_12.override {
  #  argsOverride = rec {
  #  	src = pkgs.fetchurl {
  #      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
  #      sha256 = "sha256-nRrjmi6gJNmWRvZF/bu/pFRVdxMromQ+Ad914yJG1sc=";
  #    };
  #    version = "6.12.21";
  #    modDirVersion = "6.12.21";
  #  };
  #});

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPatches = lib.singleton {
  #  name = "enable-uhid";
  #  patch = null;
  #  extraStructuredConfig = with lib.kernel; {
  #    HID = yes;
  #    UHID = yes;
  #    INPUT_UINPUT = yes;
  #  };
  #};

  boot.extraModulePackages = with config.boot.kernelPackages; [
    #rtl8812au
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
  environment.variables.MOZ_ENABLE_WAYLAND = "0";

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

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  services.transmission = { 
    enable = true; #Enable transmission daemon
    openRPCPort = true; #Open firewall for RPC
    settings = { #Override default settings
      rpc-bind-address = "0.0.0.0"; #Bind to own IP
      rpc-whitelist = "127.0.0.1,10.0.0.1"; #Whitelist your remote machine (10.0.0.1 in this example)
    };
  };

  # Gamecube controller support
  services.udev.enable = true;
  services.udev.packages = [ pkgs.dolphin-emu ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    (callPackage ../../pkgs/sekirofpsunlock {})
    wget
    joycond
    samba
    cifs-utils
    openssl
    powershell
    winetricks
    lxqt.lxqt-policykit
    networkmanagerapplet
    transmission_4-qt
    dotnetCorePackages.sdk_9_0
    pkgs.adwaita-icon-theme
    appimagekit
    (unityhub.override { extraLibs = { ... }: [ harfbuzz ]; })
    dolphin-emu
    libusb1
    udev
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

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  system.stateVersion = "24.05";
}
