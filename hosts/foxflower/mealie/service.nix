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
    # Restart mealie automatically when a secret changes.
    restartUnits = [ "mealie.service" ];
  };

  services.mealie = {
    enable = true;
    port = 9925;
    # Load OIDC_CLIENT_ID / OIDC_CLIENT_SECRET into the service as an
    # EnvironmentFile. Without this the sops template is generated but never
    # read, so mealie sees no client id and hides the SSO button.
    credentialsFile = config.sops.templates."mealie.env".path;
    settings = {
      # Mealie builds the OIDC redirect_uri from BASE_URL; it must be the
      # public URL, not the module default of http://localhost:9925.
      BASE_URL = "https://mealie.foxflower.tech";
      OIDC_AUTH_ENABLED = true;
      OIDC_SIGNUP_ENABLED = true;
      OIDC_CONFIGURATION_URL = "https://authentik.foxflower.tech/application/o/mealie/";
      OIDC_PROVIDER_NAME = "Foxflower";
    };
  };
}
