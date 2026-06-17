{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
    name = "padctl";

    src = pkgs.fetchurl {
        url = "https://github.com/BANANASJIM/padctl/releases/download/v0.1.4/padctl-v0.1.4-x86_64-linux-musl.tar.gz";
        sha256 = "sha256-g0HS8/aVw7aF5d2Fn/3kk7WTKBBoR4rXDIhmHw7BUx4=";
    };

    phases = "unpackPhase unpackPhaseExport";

    unpackPhase = ":";

    unpackPhaseExport = ''
        cp $src padctl-v0.1.0-aarch64-linux-musl.tar.gz 
        tar -xvzf padctl-v0.1.0-aarch64-linux-musl.tar.gz 
        mkdir -p $out/bin
        mkdir -p $out/etc/udev/rules.d
        mkdir -p $out/lib/systemd/system
        mkdir -p $out/etc/padctl/devices/flydigi

        cp padctl-v0.1.4-x86_64-linux-musl/bin/padctl $out/bin/padctl
        cp padctl-v0.1.4-x86_64-linux-musl/bin/padctl-capture $out/bin/padctl-capture
        cp padctl-v0.1.4-x86_64-linux-musl/bin/padctl-debug $out/bin/padctl-debug
        cp padctl-v0.1.4-x86_64-linux-musl/install/padctl-reconnect $out/bin/padctl-reconnect

        cp padctl-v0.1.4-x86_64-linux-musl/install/padctl.service $out/lib/systemd/system/padctl.service
        #cp padctl-v0.1.4-x86_64-linux-musl/install/padctl-resume.service $out/lib/systemd/system/padctl-resume.service
        cp padctl-v0.1.4-x86_64-linux-musl/install/60-padctl.rules $out/etc/udev/rules.d/60-padctl.rules
        cp padctl-v0.1.4-x86_64-linux-musl/install/61-padctl-driver-block.rules $out/etc/udev/rules.d/61-padctl-driver-block.rules

        cp padctl-v0.1.4-x86_64-linux-musl/devices/flydigi/vader5.toml $out/etc/padctl/devices/flydigi/vader5.toml
    ''; 
}