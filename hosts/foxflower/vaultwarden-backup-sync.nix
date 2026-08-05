{ config, pkgs, ... }:
let
  backupDir = config.services.vaultwarden.backupDir;

  # rclone config path once decrypted by sops (owned by the vaultwarden user).
  rcloneConf = config.sops.secrets."vaultwarden/rclone_conf".path;

  syncScript = pkgs.writeShellApplication {
    name = "vaultwarden-remote-sync";
    runtimeInputs = [ pkgs.rclone pkgs.coreutils ];
    text = ''
      set -euo pipefail

      # rclone rewrites refreshed OAuth tokens back into its config file, so it
      # needs a WRITABLE config. Copy the (read-only) sops secret into the unit's
      # RuntimeDirectory, which is cleared when the service stops.
      runtime="''${RUNTIME_DIRECTORY%%:*}"
      conf="$runtime/rclone.conf"
      install -m 600 "${rcloneConf}" "$conf"

      stamp="$(date +%Y-%m-%d)"

      # Mirror the latest local snapshot to the encrypted remote. Any file that is
      # replaced or removed on the remote is moved into a dated archive folder,
      # giving us point-in-time version history instead of a destructive mirror.
      rclone --config "$conf" sync \
        "${backupDir}" \
        gdrive-crypt:current \
        --backup-dir "gdrive-crypt:archive/$stamp" \
        --exclude '/icon_cache/**' \
        --log-level INFO

      # Keep ~90 days of history.
      rclone --config "$conf" delete --min-age 90d gdrive-crypt:archive || true
      rclone --config "$conf" rmdirs --leave-root gdrive-crypt:archive || true
    '';
  };
in {
  # The rclone remote definition (Google Drive OAuth token + crypt passwords)
  # is sensitive, so it lives in the encrypted secrets file. Add it with:
  #     sops hosts/foxflower/secrets/vaultwarden.yaml
  # under:  vaultwarden.rclone_conf: |  (the full rclone.conf contents)
  sops.secrets."vaultwarden/rclone_conf" = {
    sopsFile = ./secrets/vaultwarden.yaml;
    owner = "vaultwarden";
    group = "vaultwarden";
    mode = "0400";
  };

  # Fire the offsite sync automatically after each SUCCESSFUL local backup.
  systemd.services.backup-vaultwarden.unitConfig.OnSuccess =
    "vaultwarden-remote-sync.service";

  systemd.services.vaultwarden-remote-sync = {
    description = "Sync Vaultwarden backups to remote storage (rclone → Google Drive)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "vaultwarden";
      Group = "vaultwarden";
      ExecStart = "${syncScript}/bin/vaultwarden-remote-sync";

      RuntimeDirectory = "vaultwarden-remote-sync";
      RuntimeDirectoryMode = "0700";
      Environment = [ "HOME=%t/vaultwarden-remote-sync" ];

      # Hardening — read-only view of the system, only needs to read the backup.
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      ReadOnlyPaths = [ backupDir ];
    };
  };
}
