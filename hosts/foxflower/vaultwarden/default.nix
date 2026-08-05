# Vaultwarden (Bitwarden-compatible server) for foxflower.
# See ./README.md for backup, restore, and recovery-key documentation.
{ ... }: {
  imports = [
    ./service.nix # the vaultwarden service, secrets, and rendered env file
    ./backup-sync.nix # offsite (rclone → Google Drive) sync of the local backups
  ];
}
