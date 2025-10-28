{ config, pkgs, ... }:

{
    home.file."start_firefox.sh".source = ./start_firefox.sh;
}
