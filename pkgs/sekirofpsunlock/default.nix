pkgs.stdenv.mkDerivation {
    name = "sekirofpsunlock";

    src = pkgs.fetchurl {
        name = "hello_static";
        url = "https://github.com/Lahvuun/sekirofpsunlock/releases/download/v0.2.3/sekirofpsunlock-v0.2.3-x86_64-musl.tar.gz";
        sha256 = "sha256:somE27ajbm0TtWv9tyeqTWDW3gbIs6xvlcFS9QS1ZJ0=";
    };

    phases = [ "installPhase" ];

    installPhase = ''
        tar xf sekirofpsunlock-v0.2.3-x86_64-musl.tar.gz -C $out
    '';
}