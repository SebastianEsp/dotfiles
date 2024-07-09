{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}: {

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  environment.systemPackages = with pkgs; [
    inputs.kwin-scripts.packages.${stdenv.system}.virtual-desktops-only-on-primary
  ];
}
