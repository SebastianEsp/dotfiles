{
  config,
  ...
}: {
  # --- Agent pairing secrets (sops-nix) --------------------------------------
  # KEY (hub public key) and TOKEN come from the hub UI: launch the hub, click
  # "Add System", and copy the values it shows. Then:
  #     sops hosts/foxflower/beszel/secrets.yaml   # add beszel/key and beszel/token
  # and uncomment the three blocks below + the environmentFile line.
  #
  # sops.secrets."beszel/key".sopsFile = ./secrets.yaml;
  # sops.secrets."beszel/token".sopsFile = ./secrets.yaml;
  #
  # sops.templates."beszel-agent.env" = {
  #   content = ''
  #     KEY=${config.sops.placeholder."beszel/key"}
  #     TOKEN=${config.sops.placeholder."beszel/token"}
  #   '';
  #   restartUnits = [ "beszel-agent.service" ];
  # };

  services.beszel.agent = {
    enable = true;
    smartmon.enable = true;
    # environmentFile = config.sops.templates."beszel-agent.env".path;
    environment = {
      HUB_URL = "https://beszel.foxflower.tech";
      LISTEN = "45876";
    };
  };

  services.beszel.hub = {
    enable = true;
    port = 3002;
    environment = {
      APP_URL = "https://beszel.foxflower.tech";
      USER_CREATION = "true";
    };
  };
}
