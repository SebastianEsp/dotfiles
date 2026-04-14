{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "sekirofpsunlock";

    src = pkgs.fetchurl {
        url = "https://github.com/BANANASJIM/padctl/releases/download/v0.1.0/padctl-v0.1.0-x86_64-linux-musl.tar.gz";
        sha256 = "sha256-e5da277b9887480d85636575f50d76801c659e79b49d6a02b06627fff69ec631";
    };

    phases = "unpackPhase unpackPhaseExport";

    unpackPhase = ":";

    unpackPhaseExport = ''
        cp $src padctl-v0.1.0-aarch64-linux-musl.tar.gz 
        tar -xvzf padctl-v0.1.0-aarch64-linux-musl.tar.gz 
        mkdir -p $out/bin
        cp padctl $out/bin/
    '';
}