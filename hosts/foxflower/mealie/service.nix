{
  config,
  ...
}: {

  sops.secrets."mealie/oidc_client_id".sopsFile = ./secrets.yaml;
  sops.secrets."mealie/oidc_client_secret".sopsFile = ./secrets.yaml;

  # Render the runtime env file from the decrypted secrets. This file lives on
  # tmpfs (/run/secrets/rendered/...), never in the world-readable Nix store.
  sops.templates."vaultwarden.env" = {
    content = ''
      OIDC_CLIENT_ID=${config.sops.placeholder."mealie/oidc_client_id"}
      OIDC_CLIENT_SECRET=${config.sops.placeholder."mealie/oidc_client_secret"}
    '';
    # Restart vaultwarden automatically when a secret changes.
    restartUnits = [ "vaultwarden.service" ];
  };

  services.mealie = {
    enable = true;
    port = 9925;
    settings = {
      OIDC_AUTH_ENABLED = true;
      OIDC_SIGNUP_ENABLED = true;
      OIDC_CONFIGURATION_URL = "";
      OIDC_PROVIDER_NAME = "Foxflower"
    };
  };
}
