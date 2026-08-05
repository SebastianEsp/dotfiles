# Vaultwarden (foxflower)

Self-hosted Bitwarden-compatible password server, plus encrypted secrets, a
nightly local backup, and an offsite (Google Drive) sync of that backup.

## Files

| File | Purpose |
|------|---------|
| `default.nix` | Aggregator — imports the two modules below. `configuration.nix` imports this folder. |
| `service.nix` | The `services.vaultwarden` config, its sops secrets, and the rendered env file. |
| `backup-sync.nix` | `vaultwarden-remote-sync` service that rclone-syncs local backups offsite. |
| `secrets.yaml` | **sops-encrypted** secrets (SMTP creds, admin token, SSO creds, rclone config). Safe to commit. |
| `README.md` | This file. |

## Important paths

| What | Path |
|------|------|
| Live data dir (`DATA_FOLDER`) | `/var/lib/bitwarden_rs` |
| Local backup dir (`backupDir`) | `/var/local/vaultwarden/backup` |
| Rendered env file (tmpfs) | `config.sops.templates."vaultwarden.env".path` (`/run/secrets/rendered/...`) |

## Secrets (sops-nix)

Values live encrypted in `secrets.yaml` and are decrypted at activation time.
Edit with (from repo root):

```bash
sops hosts/foxflower/vaultwarden/secrets.yaml
```

Structure (all nested under `vaultwarden:`, 4-space indent):

```yaml
vaultwarden:
    smtp_username: ...
    smtp_password: ...
    admin_token: ...
    sso_client_id: ...
    sso_client_secret: ...
    rclone_conf: |
        [gdrive]
        ...
        [gdrive-crypt]
        ...
```

### Recovery / decryption keys

`secrets.yaml` is encrypted to three age recipients (see `/.sops.yaml`). **Any one**
can decrypt:

| Recipient | Private key location | Role |
|-----------|----------------------|------|
| `admin_sebastian` | `~/.config/sops/age/keys.txt` (workstation) | Day-to-day editing |
| `host_foxflower`  | `/etc/ssh/ssh_host_ed25519_key` (server) | Runtime decryption at activation |
| `recovery_coldstorage` | **offline** (paper / safe) | Last-resort recovery |

If you add/rotate a recipient, re-encrypt existing files:
`sops updatekeys hosts/foxflower/vaultwarden/secrets.yaml`.

## Backup

### Local (built into the NixOS module)

Setting `backupDir` enables a `backup-vaultwarden` systemd service + timer:

- **Schedule:** daily at **23:00** (`Persistent = true`, so it catches up after downtime).
- **What it does:** a consistent SQLite `.backup` of `db.sqlite3`, then `cp -r`
  of everything else in the data dir (`attachments/`, `sends/`, `rsa_key.pem`,
  `config.json`, `icon_cache/`) into `backupDir`.

So `backupDir` always holds a complete, restore-ready snapshot.

Run it manually:

```bash
sudo systemctl start backup-vaultwarden.service
```

### Offsite (rclone → Google Drive, encrypted)

`backup-sync.nix` adds `vaultwarden-remote-sync.service`, wired to run via
`OnSuccess=` **after each successful local backup** (no cron, and a failed backup
never uploads).

- Uploads through an rclone **crypt** remote (`gdrive-crypt`), so file contents
  **and names are encrypted at rest** — Google can't read the vault DB.
- Mirrors the snapshot to `gdrive-crypt:current`; any replaced/removed file is
  moved to `gdrive-crypt:archive/YYYY-MM-DD/` for **point-in-time history**.
- Prunes archived versions older than **90 days**.
- Skips `icon_cache/` (re-downloadable junk).

Check the last run:

```bash
journalctl -u vaultwarden-remote-sync.service -n 50 --no-pager
```

List what's on the remote (names are encrypted — rclone decrypts them):

```bash
sudo -u vaultwarden rclone --config /run/vaultwarden-remote-sync/rclone.conf ls gdrive-crypt:current
```

## Restore

### From the local backup (fastest — server still alive)

```bash
sudo systemctl stop vaultwarden

sudo install -o vaultwarden -g vaultwarden -m 600 \
  /var/local/vaultwarden/backup/db.sqlite3 /var/lib/bitwarden_rs/db.sqlite3

# plus the non-db files (attachments, sends, keys, config)
sudo cp -r /var/local/vaultwarden/backup/{attachments,sends,rsa_key.pem,config.json} \
  /var/lib/bitwarden_rs/ 2>/dev/null || true
sudo chown -R vaultwarden:vaultwarden /var/lib/bitwarden_rs

sudo systemctl start vaultwarden
```

### From the offsite copy (server lost / rebuilt)

1. Have an rclone config with the `gdrive`/`gdrive-crypt` remotes. You can pull
   it out of `secrets.yaml` (`sops -d ... | yq '.vaultwarden.rclone_conf'`) using
   any of the three recovery keys.
2. Pull the latest snapshot:

   ```bash
   rclone --config <rclone.conf> copy gdrive-crypt:current /var/local/vaultwarden/backup
   ```

   For an older point in time, copy from `gdrive-crypt:archive/<date>/` instead.
3. Then follow the local-restore steps above.

> The vault entries are additionally encrypted with each user's master-password
> key, so even a fully restored DB is useless without users' master passwords —
> that's expected. `rsa_key.pem` only signs session JWTs; if it's missing,
> everyone is simply logged out and re-authenticates.

## Deploying changes

From the repo root (secrets must be **staged** — flakes only see git-tracked content):

```bash
git add hosts/foxflower/vaultwarden
make rebuild        # runs on foxflower
```
