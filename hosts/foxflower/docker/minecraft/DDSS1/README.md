# DDSS1 - Dungeons, Dragons and Space Shuttles

Minecraft 1.12.2 server running the [DDSS modpack](https://www.curseforge.com/minecraft/modpacks/dungeons-dragons-and-space-shuttles).

## First-time setup

### 1. Download the server pack
Go to the DDSS CurseForge page → **Files** tab, find the version you want, and download the file labeled **Server Pack** (`.zip`).

### 2. Extract to the data directory
```
mkdir -p /docker/minecraft/ddss1
unzip ddss-serverpack.zip -d /docker/minecraft/ddss1/
```
After extraction `/docker/minecraft/ddss1/` should contain `mods/`, `config/`, and other folders.

### 3. Check the Forge version
Look for a file in the extracted folder named like `forge-1.12.2-14.23.5.2847-installer.jar`. The number after `1.12.2-` is the Forge version. Verify it matches `FORGEVERSION` in `docker-compose.yaml`.

### 4. Start the container
```
docker compose up -d
```
First startup takes a few minutes as Forge installs and ~500 mods load.

### 5. Client setup
Install the same version of the DDSS modpack on your client via the CurseForge launcher. The client and server pack versions must match.

## Management

### Attach to the server console
```
docker attach mc-ddss1
```
Detach without stopping the server: `Ctrl+P` then `Ctrl+Q`

### Send a single command without attaching
```
docker exec -i mc-ddss1 rcon-cli <command>
```

### Restart the container
```
docker compose restart
```

### Recreate the container (required after compose changes)
```
docker compose down && docker compose up -d
```
