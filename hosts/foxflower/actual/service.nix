{ ... }: {
  # Actual Budget (https://github.com/actualbudget/actual). No secrets in Nix:
  # the server password is set in the browser on first visit and stored hashed
  # in ${dataDir}/server-files/account.sqlite.
  services.actual = {
    enable = true;
    settings = {
      # Only reachable through traefik, which proxies actual.foxflower.tech to
      # this port. The module default of "::" would expose it on the LAN.
      hostname = "127.0.0.1";
      port = 3000;
    };
  };
}
