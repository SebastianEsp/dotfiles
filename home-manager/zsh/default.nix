{ config, pkgs, ... }:

{
 # zsh configuration
  programs.zsh = {
    enable = true;
    initContent = (builtins.readFile ./zshrc);
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  #home.file.".zshrc".source = ./zshrc;
  home.file.".p10k.zsh".source = ./p10k.zsh;
 
}
