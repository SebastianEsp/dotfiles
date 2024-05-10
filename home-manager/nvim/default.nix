{ config, pkgs, ... }:

{
  # NVIM configuration
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  
  home.file.".vimrc".source = ./vimrc;

}
