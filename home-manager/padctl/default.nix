{ config, pkgs, ... }:

{
  
  home.file.".config/padctl/devices/vader5.toml".source = ./vader5.toml;

}
