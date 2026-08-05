{
  config,
  ...
}: {

  sops.secrets."mealie/oidc_client_id".sopsFile = ./secrets.yaml;
  sops.secrets."mealie/oidc_client_secret".sopsFile = ./secrets.yaml;

  sops.templates."mealie.env" = {
    content = ''
      OIDC_CLIENT_ID=${config.sops.placeholder."mealie/oidc_client_id"}
      OIDC_CLIENT_SECRET=${config.sops.placeholder."mealie/oidc_client_secret"}
    '';
    # Restart vaultwarden automatically when a secret changes.
    restartUnits = [ "mealie.service" ];
  };

  services.mealie = {
    enable = true;
    port = 9925;
    settings = {
      OIDC_AUTH_ENABLED = true;
      OIDC_SIGNUP_ENABLED = true;
      OIDC_CONFIGURATION_URL = "https://authentik.foxflower.tech/application/o/mealie/";
      OIDC_PROVIDER_NAME = "Foxflower";
    };
  };
}
