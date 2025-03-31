{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "sekirofpsunlock";

    src = pkgs.fetchurl {
        url = "https://github.com/Lahvuun/sekirofpsunlock/releases/download/v0.2.3/sekirofpsunlock-v0.2.3-x86_64-musl.tar.gz";
        sha256 = "sha256-BReGWCAMx8ZqURh6JdjEtpksA8KpCMwAi11LSjPAiBY=";
    };

    phases = "unpackPhase unpackPhaseExport";

    unpackPhase = ":";

    unpackPhaseExport = ''
        cp $src sekirofpsunlock-v0.2.3-x86_64-musl.tar.gz
        tar -xvzf sekirofpsunlock-v0.2.3-x86_64-musl.tar.gz
        mkdir -p $out/bin
        cp sekirofpsunlock $out/bin/
    '';
}