
# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  sekirofpsunlock = pkgs.callPackage ./sekirofpsunlock { };
  xpadneo_0_9_8 = pkgs.callPackage ./xpadneo { };
}


