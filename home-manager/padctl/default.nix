{ config, pkgs, ... }:

{
  
  home.file.".config/padctl/devices/".source = ./vader5.toml;

}
