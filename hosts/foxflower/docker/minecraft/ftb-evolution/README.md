# FTB Evolution

Minecraft NeoForge 1.21.1 server. Runs on port **25566** (DDSS1 owns 25565).

Reachable at **`ftb-evolution.foxflower.tech`** via a DNS SRV record (see below), so
players don't need to type the port.

Modpack: [FTB Evolution](https://www.feed-the-beast.com/modpacks/125-ftb-evolution)
(modpack ID `125`), pinned to version `1.40.0` (version ID `100436`).

## First-time setup

The server uses `TYPE=FTBA`, so the [itzg/minecraft-server] image **downloads the
modpack and installs the matching NeoForge version automatically** on first start —
there is no server pack to download or unzip by hand, and no CurseForge API key.

```
docker compose up -d
```

First startup takes several minutes while it fetches and installs the pack and mods.
Watch progress with `docker logs -f mc-ftb-evolution`.

### Client setup
Install the matching FTB Evolution version (`1.40.0`) on your client via the FTB App.
Client and server versions must match.

### Upgrading the modpack
Bump `FTB_MODPACK_VERSION_ID` in `docker-compose.yaml` to the new version's ID (hover a
server-file entry on the FTB versions page to find it), then
`docker compose down && docker compose up -d`. Remove that line entirely to always
track the latest release (it re-checks on each restart).

[itzg/minecraft-server]: https://docker-minecraft-server.readthedocs.io/

## DNS / subdomain (`ftb-evolution.foxflower.tech`)

Minecraft's Java protocol is raw TCP, not HTTP, so it does **not** go through Traefik.
Connectivity is handled entirely by DNS + the firewall:

- Firewall port `25566` is opened in `hosts/foxflower/configuration.nix`.
- A DNS **SRV** record maps the subdomain to the port so players can connect with just
  `ftb-evolution.foxflower.tech` (no `:25566`).

Add these records at the registrar for `foxflower.tech`:

| Type | Host / Name                        | Value                                    |
|------|------------------------------------|------------------------------------------|
| SRV  | `_minecraft._tcp.ftb-evolution`    | priority `0`, weight `5`, port `25566`, target `foxflower.tech` |

The SRV target `foxflower.tech` already has an A record (`94.147.71.30`), so no extra
A record is needed. If your registrar's SRV form requires the service/protocol as
separate fields: service `_minecraft`, protocol `_tcp`, name `ftb-evolution`.

Players can still connect directly with `ftb-evolution.foxflower.tech:25566` before DNS
propagates.

## Management

### Attach to the server console
```
docker attach mc-ftb-evolution
```
Detach without stopping the server: `Ctrl+P` then `Ctrl+Q`

### Send a single command without attaching
```
docker exec -i mc-ftb-evolution rcon-cli <command>
```

### Restart the container
```
docker compose restart
```

### Recreate the container (required after compose changes)
```
docker compose down && docker compose up -d
```
</content>
</invoke>
