{ config, ... }: {
  # --- Secrets (managed with sops-nix) ---------------------------------------
  # Encrypted values live in ./secrets/vaultwarden.yaml and are decrypted at
  # activation time using foxflower's SSH host key. Create/edit them with:
  #     sops hosts/foxflower/secrets/vaultwarden.yaml
  sops.secrets."vaultwarden/smtp_username".sopsFile = ./secrets/vaultwarden.yaml;
  sops.secrets."vaultwarden/smtp_password".sopsFile = ./secrets/vaultwarden.yaml;
  sops.secrets."vaultwarden/admin_token".sopsFile = ./secrets/vaultwarden.yaml;

  # Render the runtime env file from the decrypted secrets. This file lives on
  # tmpfs (/run/secrets/rendered/...), never in the world-readable Nix store.
  sops.templates."vaultwarden.env" = {
    content = ''
      SMTP_USERNAME=${config.sops.placeholder."vaultwarden/smtp_username"}
      SMTP_PASSWORD=${config.sops.placeholder."vaultwarden/smtp_password"}
      ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin_token"}
      SSO_CLIENT_ID=${config.sops.placeholder."vaultwarden/sso_client_id"}
      SSO_CLIENT_SECRET=${config.sops.placeholder."vaultwarden/sso_client_secret"}
    '';
    # Restart vaultwarden automatically when a secret changes.
    restartUnits = [ "vaultwarden.service" ];
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    # Secrets (SMTP creds + ADMIN_TOKEN) are supplied via this sops-rendered
    # env file instead of the Nix store.
    environmentFile = config.sops.templates."vaultwarden.env".path;
    config = {
      # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://vaultwarden.foxflower.tech";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      # External mail server (Proton). See:
      #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
      SMTP_HOST = "smtp.protonmail.ch";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";

      SMTP_FROM = "mail@foxflower.tech";
      SMTP_FROM_NAME = "foxflower.tech Bitwarden server";

      SSO_ENABLED = true
      SSO_AUTHORITY = "https://authentik.foxflower.tech/application/o/vaultwarden/"
    };
  };
}
