{pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sebastian = {
    isNormalUser = true;
    description = "Sebastian Esp";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.space-mono
  ];
}
