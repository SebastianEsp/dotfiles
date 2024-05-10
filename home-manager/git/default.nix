{ config, pkgs, ... }:

{
 # Git configuration
  programs.git = {
    enable = true;
    userName = "SebastianEsp";
    userEmail = "sebastianesp@hotmail.com";
    extraConfig = {
      core.editor = "vim";
    };
    aliases = {
      st = "status";
      cm = "commit -m";
      pu = "push";
    };
  }; 
}
